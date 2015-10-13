require_relative '../../rails_helper.rb'
require_relative '../../current_user_shared'
require_relative '../../authenticate_admin_shared'

describe Admin::UsersController do
  def admin_sign_in
    @admin = create(:admin)
    sign_in @admin
  end

  it_behaves_like 'current_user'

  describe 'Callbacks' do
    it { is_expected.to use_before_action(:load_user) }
  end

  context 'GET index' do
    def send_request(params={})
      get :index, params
    end

    it_behaves_like 'authenticate_admin'

    before do
      admin_sign_in
      user2 = create(:user)
      User.stub(:order).and_return([@admin, user2])
    end

    it 'should return all users' do
      send_request
      is_expected.to render_template(:index)
    end
  end

  context 'PUT enable' do
    def send_request(params = {})
      put :enable, params.merge(user_id: 1)
    end

    it_behaves_like 'authenticate_admin'

    context 'user doesnt exists' do
      before do
        User.stub(:find_by).and_return(false)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'user exists' do
      context 'user is successfully enabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request
            is_expected.to redirect_to(root_path)
            is_expected.to set_flash[:success]
          end
        end
        context 'via json request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
      context 'user cannot be enabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(false)
          end
          it 'should redirect to previous page' do
            send_request
            is_expected.to redirect_to(root_path)
            is_expected.to set_flash[:error]
          end
        end
        context 'via json request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(false)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
    end
  end

  context 'PUT disable' do
    def send_request(params = {})
      put :disable, params.merge(user_id: 1)
    end

    it_behaves_like 'authenticate_admin'

    context 'user doesnt exists' do
      before do
        User.stub(:find_by).and_return(false)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'user exists' do
      context 'user is successfully disabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request
            is_expected.to redirect_to(root_path)
            is_expected.to set_flash[:success]
          end
        end
        context 'via json request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
      context 'user cannot be disabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(false)
          end
          it 'should redirect to previous page' do
            send_request
            is_expected.to redirect_to(root_path)
            is_expected.to set_flash[:error]
          end
        end
        context 'via json request' do
          before do
            admin_sign_in
            user = double(User)
            User.stub(:find_by).and_return(user)
            request.env['HTTP_REFERER'] = root_path
            user.stub(:update).and_return(false)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
    end



  end

end
