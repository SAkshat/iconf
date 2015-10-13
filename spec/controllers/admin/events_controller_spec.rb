require_relative '../../rails_helper.rb'
require_relative '../../current_user_shared'
require_relative '../../authenticate_admin_shared'

describe Admin::EventsController do
  def admin_sign_in
    @admin = create(:admin)
    sign_in @admin
  end

  it_behaves_like 'current_user'

  describe 'Callbacks' do
    it { is_expected.to use_before_action(:load_event) }
  end

  context 'GET index' do
    def send_request(params={})
      get :index, params
    end

    it_behaves_like 'authenticate_admin'

    before do
      admin_sign_in
      event = double(Event)
      Event.stub(:order).and_return([event])
    end

    it 'should return all events' do
      send_request
      is_expected.to render_template(:index)
    end
  end

  context 'PUT enable' do
    def send_request(params = {})
      put :enable, params.merge(id: 1)
    end

    it_behaves_like 'authenticate_admin'

    context 'event doesnt exists' do
      before do
        Event.stub(:find_by).and_return(false)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'event exists' do
      context 'event is successfully enabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(true)
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
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
      context 'event cannot be enabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(false)
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
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(false)
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
      put :disable, params.merge(id: 1)
    end

    it_behaves_like 'authenticate_admin'

    context 'event doesnt exists' do
      before do
        Event.stub(:find_by).and_return(false)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'event exists' do
      context 'event is successfully disabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(true)
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
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
      context 'event cannot be disabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(false)
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
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            event.stub(:update).and_return(false)
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

  context 'GET show' do
    def send_request(params = {})
      get :show, params.merge(id: 1)
    end

    it_behaves_like 'authenticate_admin'

    context 'event doesnt exists' do
      before do
        Event.stub(:find_by).and_return(false)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'event exists' do
      before do
        admin_sign_in
        event = double(Event)
        discussion = double(Discussion)
        Event.stub(:find_by).and_return(event)
        event.stub(:discussions).and_return(discussion)
        discussion.stub(:order).and_return(discussion)
      end
      it 'should render template show' do
        send_request
        is_expected.to render_template(:show)
      end
    end

  end

end
