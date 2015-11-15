# Journey controller
class JourneysController < ApplicationController
  def create
    @journey = Journey.create_with_path(journey_params, current_user)
    render json: { status: :created, journey: @journey }
  rescue StandardError => e
    render json: { status: :unprocessable_entity, error: e }
  end

  def journey_params
    params.require(:journey).permit(:date, :spaces, path: [:time, point: []])
  end
end
