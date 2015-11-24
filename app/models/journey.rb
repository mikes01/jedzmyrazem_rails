# Model for manage journeys
class Journey < ActiveRecord::Base
  belongs_to :driver, class_name: 'User', foreign_key: :driver_id
  has_many :waypoints

  def self.create_with_path(journey_with_path, user)
    Journey.transaction do
      journey = Journey.create!(date: journey_with_path[:date],
                                spaces: journey_with_path[:spaces],
                                driver: user)
      Waypoint.create_from_array(journey_with_path[:path], journey)
      journey
    end
  end

  def format
    result = as_json
    result['waypoints'] = []
    waypoints.each do |waypoint|
      result['waypoints'].push("point":
        { "lat": waypoint.point.x, "lng": waypoint.point.y },
                               "time": waypoint.time)
    end
    result['user'] = driver.username
    result
  end

  def self.search_journeys(parameters)
    candidates = Journey.get_journeys_in_period(parameters[:start_time],
                                                parameters[:date])
    sorted_js = Journey.sort_journeys(candidates, parameters)
    Journey.get_matched_journeys_from_sorted_journeys(sorted_js)
  end

  def self.get_journeys_in_period(start_time, date)
    Journey.includes(:waypoints).where(date: date)
      .where('waypoints.time BETWEEN ? AND ?', start_time,
             (Time.zone.parse(start_time) + 2.hour).to_formatted_s(:db))
      .references(:waypoints)
  end

  def find_start_and_finish(parameters)
    start = find_point(parameters[:start_lat], parameters[:start_lng])
    finish = find_point(parameters[:finish_lat], parameters[:finish_lng])
    [start, finish]
  end

  def find_point(lat, lng)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    p = factory.point(lat, lng)
    waypoints.each_with_index do |w, i|
      return i if p.distance(w.point) < 1000
    end
    nil
  end

  def self.sort_journeys(journeys, parameters)
    sorted_js = { direct: [], with_start: [], with_finish: [], rest: [] }
    journeys.each_with_index do |journey|
      start, finish = journey.find_start_and_finish(parameters)
      sorted_js[journey
        .choose_category(start, finish)].push journey: journey,
                                              start: start,
                                              finish: finish
    end
    sorted_js
  end

  def choose_category(start, finish)
    if !start.nil? && !finish.nil? && start < finish
      return :direct
    elsif !start.nil?
      return :with_start
    elsif !finish.nil?
      return :with_finish
    else
      return :rest
    end
  end

  def self.get_matched_journeys_from_sorted_journeys(sorted_js)
    results = find_direct_journeys(sorted_js)
    sorted_js[:with_start].each do |j|
      matched_js =
        Journey.match_with_journeys_from_array(j, sorted_js[:with_finish])
      results.concat matched_js
    end
    results.concat Journey.find_complex_journeys(sorted_js, 4)
  end

  def self.find_direct_journeys(sorted_js)
    results = []
    sorted_js[:direct].each do |j|
      results.push passes: [j[:journey].format],
                   intersections: [], start: j[:start], finish: j[:finish]
    end
    results
  end

  def self.match_with_journeys_from_array(journey, array_of_journeys)
    results = []
    array_of_journeys.each do |j|
      p1, p2 = journey[:journey].find_intersection_point(j[:journey])
      if self.possible_connection?(p1, p2, journey[:start], j[:finish])
        results.push passes: [journey[:journey].format, j[:journey].format],
                     intersections: [p1, p2]
      end
    end
    results
  end

  def self.possible_connection?(p1, p2, j1_start, j2_finish)
    !p1.nil? && !p2.nil? && p1 > j1_start && p2 < j2_finish
  end

  def find_intersection_point(journey, min = 1, max = -2)
    journey.waypoints[0..max].each_with_index do |point, i|
      waypoints[min..-1].each_with_index do |self_point, j|
        if point.point.distance(self_point.point) < 1000 &&
           point.time > self_point.time
          return j + min, i
        end
      end
    end
    [nil, nil]
  end

  def self.find_complex_journeys(sorted_js, max_passes)
    results = []
    sorted_js[:with_start].each do |j|
      results.concat j[:journey].find_way_to_finish(sorted_js,
                                                    j[:start],
                                                    max_passes - 2)
    end
    results
  end

  def find_way_to_finish(sorted_js, start, max_middle)
    results = []
    sorted_js[:rest].each do |jr|
      p1, p2 = find_intersection_point(jr[:journey], start + 1, -2)
      next if p1.nil? || p2.nil?
      candidate = { passes: [self, jr[:journey]], intersections: [p1, p2] }
      results.push candidate unless
        jr[:journey].connect_start_rests_and_finish(
          candidate, sorted_js, max_middle - 1).nil?
    end
    results
  end

  def connect_start_rests_and_finish(candidate, sorted_js, max_middle)
    sorted_js[:with_finish].each do |jf|
      p1, p2 = find_intersection_point(jf[:journey],
                                       candidate[:intersections].last + 1,
                                       jf[:finish])
      r = find_way(candidate, max_middle, sorted_js, jf[:journey], [p1, p2])
      return r unless r.nil?
    end
    nil
  end

  def find_way(candidate, max_middle, sorted_js, finish, points)
    if not_intersect?(points.first, points.last)
      return nil if go_deeper?(max_middle, candidate, sorted_js[:rest])
      return candidate[:passes].last
        .connect_start_rests_and_finish(candidate, sorted_js, max_middle - 1)
    else
      return Journey.fill_candidate(points.first,
                                    points.last, finish, candidate)
    end
  end

  def go_deeper?(max_middle, candidate, rests)
    max_middle == 0 || !add_middle(candidate, rests)
  end

  def add_middle(candidate, journeys)
    journeys.each do |j|
      p1, p2 = candidate[:passes].last
               .find_intersection_point(j[:journey],
                                        candidate[:intersections].last + 1, -2)
      next if not_intersect?(p1, p2)
      candidate = Journey.fill_candidate(p1, p2, j[:journey], candidate)
      return true
    end
    false
  end

  def not_intersect?(p1, p2)
    p1.nil? || p2.nil?
  end

  def self.finish?(p1, p2, finish)
    !p1.nil? && !p2.nil? && p2 < finish
  end

  def self.fill_candidate(p1, p2, journey, candidate)
    candidate[:passes].push journey
    candidate[:intersections].push p1, p2
    candidate
  end
end
