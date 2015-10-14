require 'rails_helper'

shared_examples 'authenticate_user' do

  describe '#authenticate_user!' do
    context 'if user is not signed in' do
      before do
        #SPEC
        user = controller.current_user
        sign_out user if user
      end
      it 'should redirect to sign in path' do
        send_request
        is_expected.to redirect_to(new_user_session_path)
      end
    end
  end

end
