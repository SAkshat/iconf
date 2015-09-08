class API::V1::EventsController < API::V1::ApplicationController

  def index
    render json: Event.enabled_with_enabled_creator.forthcoming
  end

end
