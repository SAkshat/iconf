require 'rails_helper'

shared_examples 'current_user' do

  before do
    @user = create(:user)
  end

  context "should return the user if user logged in" do
    before do
      sign_in(@user)
    end
    it { expect(controller.current_user).to eq(@user) }
  end

  context "should return nil if user not logged in" do
    before do
      user = controller.current_user
      sign_out(user) if user
    end
    it { expect(controller.current_user).to be_nil }
  end

end
