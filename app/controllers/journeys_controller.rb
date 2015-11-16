# Journey controller
class JourneysController < ApplicationController
  respond_to :json
  def create
    @journey = Journey.create_with_path(journey_params, current_user)
    render json: { status: :created, journey: @journey }
  rescue StandardError => e
    render json: { status: :unprocessable_entity, error: e.to_s }
  end

  def search
    parameters = search_params
    @journeys = Journey.includes(:waypoints).where(date: parameters[:date])
                .where('ST_Distance(waypoints.point, '\
        "'POINT(#{parameters[:start_lat]} "\
          "#{parameters[:start_lng]})') < 500")
                .where('waypoints.time > ?', parameters[:start_time])
                .references(:waypoints)
    render json: { status: :ok, journey: @journeys }
  rescue StandardError => e
    render json: { status: :unprocessable_entity, error: e.to_s }
  end

  def journey_params
    params.require(:journey).permit(:date, :spaces, path: [:time, point: []])
  end

  def search_params
    params.require(:params).permit(:date, :start_lat, :start_lng,
                                   :finish_lat, :finish_lng, :start_time)
  end
end
