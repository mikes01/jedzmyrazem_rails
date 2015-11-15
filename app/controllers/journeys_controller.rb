# Journey controller
class JourneysController < ApplicationController
  respond_to :json
  def create
    @journey = Journey.create_with_path(journey_params, current_user)
    render json: { status: :created, journey: @journey }
    # rescue StandardError => e
    #   render json: { status: :unprocessable_entity, error: e.to_s }
  end

  def journey_params
    params.require(:journey).permit(:date, :spaces, path: [:time, point: []])
  end
end
