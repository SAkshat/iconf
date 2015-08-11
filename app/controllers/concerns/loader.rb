module Loader

  # [TODO - S] This method is useless. Also, current_user might not be the creator in every case.
  def load_creator
    @creator = current_user
    redirect_to events_path, alert: "Couldn't find the required Creator" unless @creator
  end

end
