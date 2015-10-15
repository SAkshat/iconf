require_relative '../rails_helper.rb'
require_relative '../current_user_shared'
require_relative '../authenticate_user_shared'

describe EventsController do

  it_behaves_like 'current_user'

  describe 'GET index' do
    def send_request(params={})
      get :index, params
    end

    it 'should render index template' do
      send_request
      is_expected.to render_template(:index)
    end
  end

  describe 'GET show' do
    def send_request(params={})
      get :show, params.merge(id: 1)
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_event) }
      it { is_expected.to use_before_action(:load_discussions) }
    end

    context 'event exists' do
      before do
        event = double(Event)
        discussion = double(Discussion)
        Event.stub(:find_by).and_return(event)
        event.stub(:discussions).and_return(discussion)
        discussion.stub(:includes).with(:attendees).and_return(discussion)
        discussion.stub(:enabled).and_return(discussion)
        discussion.stub(:order).with(:date, :start_time).and_return(discussion)
      end
      it 'should render show template' do
        send_request
        is_expected.to render_template(:show)
      end
    end

    context 'event doesnt exists' do
      before do
        Event.stub(:find_by).and_return(nil)
      end
      it 'should redirect to events path' do
        send_request
        is_expected.to redirect_to(events_path)
        is_expected.to set_flash[:alert]
      end
    end
  end

  describe 'GET new' do
    def send_request(params={})
      get :new, params
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    before do
      event = double(Event)
      address = double(Address)
      contact_detail = double(ContactDetail)
      Event.stub(:new).and_return(event)
      event.stub(:build_address).and_return(address)
      event.stub(:build_contact_detail).and_return(contact_detail)
    end
    it 'should render template new' do
      send_request
      is_expected.to render_template(:new)
    end
  end

  describe 'POST edit' do
    def send_request(params={})
      post :edit, params.merge(id: 1)
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_event) }
      it { is_expected.to use_before_action(:load_discussions) }
      it { is_expected.to use_before_action(:check_event_is_upcoming) }
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    context 'event exists' do
      context 'event is upcoming' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          address = double(Address)
          contact_detail = double(ContactDetail)
          Event.stub(:find_by).and_return(event)
          event.stub(:discussions).and_return(discussion)
          discussion.stub(:includes).with(:attendees).and_return(discussion)
          discussion.stub(:enabled).and_return(discussion)
          discussion.stub(:order).with(:date, :start_time).and_return(discussion)
          event.stub(:upcoming?).and_return(true)
          event.stub(:address).and_return(address)
          event.stub(:contact_detail).and_return(contact_detail)
        end
        it 'should render edit template' do
          send_request
          is_expected.to render_template(:edit)
        end
      end
      context 'event is not upcoming' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          address = double(Address)
          contact_detail = double(ContactDetail)
          Event.stub(:find_by).and_return(event)
          event.stub(:discussions).and_return(discussion)
          discussion.stub(:includes).with(:attendees).and_return(discussion)
          discussion.stub(:enabled).and_return(discussion)
          discussion.stub(:order).with(:date, :start_time).and_return(discussion)
          event.stub(:upcoming?).and_return(false)
        end
        it 'should redirect to events path' do
          send_request
          is_expected.to redirect_to(events_path)
          is_expected.to set_flash[:alert]
        end
      end
    end

    context 'event doesnt exists' do
      before do
        Event.stub(:find_by).and_return(nil)
      end
      it 'should redirect to events path' do
        send_request
        is_expected.to redirect_to(events_path)
        is_expected.to set_flash[:alert]
      end
    end
  end

  describe 'POST create' do
    def send_request(params={})
      post :create, params
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:set_discussions_speaker) }
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    context 'event which has been created is valid' do
      before do
        @event = create(:event)
        Event.stub(:new).and_return(@event)
        controller.stub(:event_params).and_return(nil)
        @event.stub(:save).and_return(true)
      end
      it 'should redirect to the event show page' do
        send_request({ event: { discussion_attributes: 'val' } })
        is_expected.to redirect_to(@event)
        is_expected.to set_flash[:success]
      end
    end

    context 'event which has been created is invalid' do
      before do
        #SPEC
        @event = create(:event)
        Event.stub(:new).and_return(@event)
        controller.stub(:event_params).and_return(nil)
        @event.stub(:save).and_return(false)
      end
      it 'should redirect to the event show page' do
        send_request({ event: { discussion_attributes: 'val' } })
        is_expected.to render_template(:new)
        is_expected.to set_flash.now[:error]
      end
    end

  end

  describe 'PUT update' do
    def send_request(params={})
      put :update, params.merge(id: 1, event: { discussion_attributes: 'val' })
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:set_discussions_speaker) }
      it { is_expected.to use_before_action(:load_event) }
      it { is_expected.to use_before_action(:check_event_is_upcoming) }
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    context 'event exists' do
      context 'event is upcoming' do
        before do
          @event = create(Event)
          discussion = double(Discussion)
          address = double(Address)
          contact_detail = double(ContactDetail)
          Event.stub(:find_by).and_return(@event)
          @event.stub(:discussions).and_return(discussion)
          discussion.stub(:includes).with(:attendees).and_return(discussion)
          discussion.stub(:enabled).and_return(discussion)
          discussion.stub(:order).with(:date, :start_time).and_return(discussion)
          @event.stub(:upcoming?).and_return(true)
        end
        context 'updated event is valid' do
          before do
            @event.stub(:update).and_return(true)
          end
          it 'should redirect to the event show page' do
            send_request
            is_expected.to redirect_to(@event)
            is_expected.to set_flash[:success]
          end
        end
        context 'updated event is invalid' do
          before do
            @event.stub(:update).and_return(false)
          end
          it 'should render edit template' do
            send_request
            is_expected.to render_template(:edit)
            is_expected.to set_flash.now[:error]
          end
        end
      end
      context 'event is not upcoming' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          address = double(Address)
          contact_detail = double(ContactDetail)
          Event.stub(:find_by).and_return(event)
          event.stub(:discussions).and_return(discussion)
          discussion.stub(:includes).with(:attendees).and_return(discussion)
          discussion.stub(:enabled).and_return(discussion)
          discussion.stub(:order).with(:date, :start_time).and_return(discussion)
          event.stub(:upcoming?).and_return(false)
        end
        it 'should redirect to events path' do
          send_request
          is_expected.to redirect_to(events_path)
          is_expected.to set_flash[:alert]
        end
      end
    end

    context 'event doesnt exists' do
      before do
        Event.stub(:find_by).and_return(nil)
      end
      it 'should redirect to events path' do
        send_request
        is_expected.to redirect_to(events_path)
        is_expected.to set_flash[:alert]
      end
    end
  end

  context 'GET search' do
    def send_request(params={})
      get :search, params
    end

    it 'should render index template' do
      send_request
      is_expected.to render_template(:index)
    end

  end
end
