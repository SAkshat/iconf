require 'rails_helper'

shared_examples 'authenticate_admin' do

  describe '#authenticate_admin' do
    context 'if user is not an admin' do
      before do
        user = create(:user)
        sign_in user
        controller.stub(:current_user).and_return(user)
        user.stub(:admin?).and_return(false)
      end
      it 'should redirect to root path' do
        send_request
        is_expected.to redirect_to(root_path)
      end
    end
  end

end
