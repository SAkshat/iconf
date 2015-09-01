class RatingsController < ApplicationController

  before_action :create_or_load_rating, only: [:create]

  def create
    @rating.update(rating_params)
    respond_to do |format|
      if @rating.save
        format.html { redirect_to :back, notice: 'Thank you for rating' }
      else
        format.html { redirect_to :back, notice: "Couldn't rate the discussion" }
      end
    end
  end

  private

    def create_or_load_rating
      @rating = Rating.find_or_create_by(rating_params.except(:rating))
    end

    def rating_params
      params.permit(:discussion_id, :user_id, :rating)
    end
end
