require_relative '../../rails_helper.rb'
require_relative '../../current_user_shared'
require_relative '../../authenticate_admin_shared'

describe Admin::DiscussionsController do
  def admin_sign_in
    @admin = create(:admin)
    sign_in @admin
  end

  it_behaves_like 'current_user'

  describe 'Callbacks' do
    it { is_expected.to use_before_action(:load_event) }
    it { is_expected.to use_before_action(:load_discussion) }
  end

  context 'PUT enable' do
    def send_request(params = {})
      put :enable, params.merge(event_id: 1, id: 1)
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

    context 'discussion doesnt exists' do
      before do
        event = double(Event)
        Event.stub(:find_by).and_return(event)
        discussion = double(Discussion)
        event.stub(:discussions).and_return(discussion)
        discussion.stub(:find_by).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'event and discussion exists' do
      context 'discussion is successfully enabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(true)
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
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
      context 'discussion cannot be enabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(false)
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
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(false)
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
      put :disable, params.merge(event_id: 1, id: 1)
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

    context 'discussion doesnt exists' do
      before do
        event = double(Event)
        Event.stub(:find_by).and_return(event)
        discussion = double(Discussion)
        event.stub(:discussions).and_return(discussion)
        discussion.stub(:find_by).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
        admin_sign_in
      end
      it 'should redirect to previous page' do
        send_request
        is_expected.to redirect_to(root_path)
        is_expected.to set_flash[:alert]
      end
    end

    context 'event and discussion exists' do
      context 'discussion is successfully disabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(true)
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
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(true)
          end
          it 'should redirect to previous page' do
            send_request(format: :json)
            # is_expected.to redirect_to(root_path)
            # is_expected.to set_flash[:success]
            expect(response.header['Content-Type']).to include 'application/json'
          end
        end
      end
      context 'discussion cannot be disabled' do
        context 'via HTML request' do
          before do
            admin_sign_in
            event = double(Event)
            Event.stub(:find_by).and_return(event)
            request.env['HTTP_REFERER'] = root_path
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(false)
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
            discussion = double(Discussion)
            event.stub(:discussions).and_return(discussion)
            discussion.stub(:find_by).and_return(discussion)
            discussion.stub(:update).and_return(false)
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
