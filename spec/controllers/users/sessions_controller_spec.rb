require_relative '../../rails_helper.rb'

describe Users::SessionsController do

  describe 'Callbacks' do
    it { is_expected.not_to use_before_action(:autheticate_user!) }
    it { is_expected.to use_before_action(:check_if_user_logged_in) }
  end

  context 'get create' do
    def send_request(params = {})
      get :create, params.merge(provider: 1)
    end

    context 'user could be created' do
      before do
        user = double(User)
        User.stub(:find_or_create_from_twitter_params).and_return(create(:user))
        request.env['omniauth.auth'] = 'temp'
      end
      it 'should log in user and redirect to root path' do
        send_request
        is_expected.to redirect_to(root_path)
      end
    end

    context 'user could not be created' do
      before do
        user = double(User)
        User.stub(:find_or_create_from_twitter_params).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
      end
      it 'should redirect to root path and set a flash message' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:error]
      end
    end

  end

end

