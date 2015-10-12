require_relative '../rails_helper.rb'
require_relative '../current_user_shared'

describe DiscussionsUsersController do

  it_behaves_like 'current_user'
  before do
    @user = create(:user)
    sign_in @user
    # controller.stub(:current_user).and_return(@user)
    discussions_user = [double(DiscussionsUser)]
    controller.current_user.stub(:discussions_users).and_return(discussions_user)
    # controller.current_user.discussions_users.stub(:create).and_return(discussions_user)
  end

    describe 'POST create' do
      def send_request(params={})
        post :create, params
      end

    context 'if discussion doesnt exists' do
      before do
        Discussion.stub(:find_by).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
        send_request
      end
      it { is_expected.to redirect_to(root_path) }
      it { is_expected.to set_flash[:error] }
    end
    context 'if discussion doesnt exists' do
      before do
        Discussion.stub(:find_by).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
        send_request
      end
      it { is_expected.to redirect_to(root_path) }
      it { is_expected.to set_flash[:error] }
    end

  end

end
