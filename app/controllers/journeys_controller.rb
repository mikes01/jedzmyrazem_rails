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
    result = Journey.search_journeys(search_params)
    render json: { status: :ok, journey: result }
  rescue StandardError => e
    render json: { status: :unprocessable_entity, error: e.to_s }
  end

  def journey_params
    params.require(:journey)
      .permit(:date, :spaces, path: [:time, :name, point: []])
  end

  def search_params
    params.permit(:date, :start_lat, :start_lng,
                  :finish_lat, :finish_lng, :start_time)
  end
end
