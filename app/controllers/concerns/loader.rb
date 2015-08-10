module Loader

  def load_creator
    @creator = current_user
    redirect_to events_path, alert: "Couldn't find the required Creator" unless @creator
  end

end
