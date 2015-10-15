require_relative '../rails_helper.rb'
require_relative '../current_user_shared'
require_relative '../authenticate_user_shared'

describe DiscussionsController do

  it_behaves_like 'current_user'

  describe 'GET index' do
    def send_request(params={})
      get :index, params.merge(event_id: 1)
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_event) }
    end

    context 'event exists' do
      before do
        @event = double(Event)
        discussion = double(Discussion)
        expect(@event).to receive(:discussions).and_return(discussion)
        expect(discussion).to receive(:enabled).and_return(discussion)
        expect(discussion).to receive(:order).and_return(discussion)
        expect(Event).to receive(:find_by).and_return(@event)
      end
      it 'should render index template' do
        send_request
        is_expected.to render_template(:index)
      end
    end
    context 'event doesnt exist' do
      before do
        expect(Event).to receive(:find_by).and_return(nil)
      end
      it 'should redirect to events path' do
        send_request
        is_expected.to redirect_to(events_path)
        is_expected.to set_flash[:alert]
      end
    end
  end

  describe 'GET show' do
    def send_request(params={})
      get :show, params.merge(id: 1, event_id: 1)
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_event) }
      it { is_expected.to use_before_action(:load_discussion) }
    end

    context 'event exists' do
      context 'discussion exists' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          expect(Event).to receive(:find_by).and_return(event)
          expect(event).to receive(:discussions).and_return(discussion)
          expect(discussion).to receive(:find_by).and_return(discussion)
        end
        it 'should render show template' do
          send_request
          is_expected.to render_template(:show)
        end
      end
      context 'discussion doesnt exists' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          expect(Event).to receive(:find_by).and_return(event)
          expect(event).to receive(:discussions).and_return(discussion)
          expect(discussion).to receive(:find_by).and_return(nil)
        end
        it 'should redirect to events discussion path' do
          send_request
          is_expected.to redirect_to(event_discussions_path)
          is_expected.to set_flash[:alert]
        end
      end
    end

    context 'event doesnt exists' do
      before do
        expect(Event).to receive(:find_by).and_return(nil)
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
      get :new, params.merge(event_id: 1)
    end
    #SPEC
    # it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    before do
      event = double(Event)
      discussion = double(Discussion)
      expect(Event).to receive(:find_by).and_return(event)
      expect(Discussion).to receive(:new).and_return(discussion)
    end
    it 'should render new template' do
      send_request
      is_expected.to render_template(:new)
    end
  end

  describe 'POST edit' do
    def send_request(params={})
      post :edit, params.merge(event_id: 1, id: 1)
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_event) }
      it { is_expected.to use_before_action(:load_discussion) }
      it { is_expected.to use_before_action(:check_if_discussion_is_past) }
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    context 'event exists' do
      context 'discussion exists' do
        context 'discussion is upcoming' do
          before do
            event = double(Event)
            discussion = double(Discussion)
            expect(Event).to receive(:find_by).and_return(event)
            expect(event).to receive(:discussions).and_return(discussion)
            expect(discussion).to receive(:find_by).and_return(discussion)
            expect(discussion).to receive(:upcoming?).and_return(true)
          end
          it 'should render edit template' do
            send_request
            is_expected.to render_template(:edit)
          end
        end
        context 'discussion is not upcoming' do
          before do
            event = double(Event)
            discussion = double(Discussion)
            expect(Event).to receive(:find_by).and_return(event)
            expect(event).to receive(:discussions).and_return(discussion)
            expect(discussion).to receive(:find_by).and_return(discussion)
            expect(discussion).to receive(:upcoming?).and_return(false)
          end
          it 'should redirect to event path' do
            send_request
            is_expected.to redirect_to(event_path)
            is_expected.to set_flash[:notice]
          end
        end
      end
      context 'discussion doesnt exist' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          expect(Event).to receive(:find_by).and_return(event)
          expect(event).to receive(:discussions).and_return(discussion)
          expect(discussion).to receive(:find_by).and_return(nil)
        end
        it 'should redirect to event discussions path' do
          send_request
          is_expected.to redirect_to(event_discussions_path)
          is_expected.to set_flash[:alert]
        end
      end
    end

    context 'event doesnt exists' do
      before do
        expect(Event).to receive(:find_by).and_return(nil)
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
      post :create, params.merge(event_id: 1)
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_event) }
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end
    context 'event exists' do
      context 'discussion which has been created is valid' do
        before do
          @event = create(:event)
          discussion = double(Discussion)
          user = double(User)
          expect(Event).to receive(:find_by).and_return(@event)
          expect(User).to receive(:find_by).and_return(user)
          expect(discussion).to receive(:speaker=).and_return(user)
          expect(controller).to receive(:discussion_params).and_return(nil)
          expect(@event).to receive(:discussions).and_return(discussion)
          expect(discussion).to receive(:new).and_return(discussion)
          expect(discussion).to receive(:save).and_return(true)
        end
        it 'should redirect to the event show page' do
          send_request({ discussion: { speaker: 'temp' } })
          is_expected.to redirect_to(@event)
          is_expected.to set_flash[:success]
        end
      end

      context 'discussion which has been created is invalid' do
        before do
          #SPEC
          @event = create(:event)
          discussion = double(Discussion)
          user = double(User)
          expect(Event).to receive(:find_by).and_return(@event)
          expect(User).to receive(:find_by).and_return(user)
          expect(discussion).to receive(:speaker=).and_return(user)
          expect(controller).to receive(:discussion_params).and_return(nil)
          expect(@event).to receive(:discussions).and_return(discussion)
          expect(discussion).to receive(:new).and_return(discussion)
          expect(discussion).to receive(:save).and_return(false)
        end
        it 'should redirect to the event show page' do
          send_request({ discussion: { speaker: 'temp' } })
          is_expected.to render_template(:new)
          is_expected.to set_flash.now[:error]
        end
      end
    end
    context 'event doesnt exist' do
      before do
        expect(Event).to receive(:find_by).and_return(nil)
      end
      it 'should redirect to events path' do
        send_request
        is_expected.to redirect_to(events_path)
      end
    end

  end

  describe 'PUT update' do
    def send_request(params={})
      put :update, params.merge(event_id: 1,id: 1, discussion: { speaker: 'val' })
    end

    describe 'Callbacks' do
      it { is_expected.to use_before_action(:load_discussion) }
      it { is_expected.to use_before_action(:load_event) }
      it { is_expected.to use_before_action(:check_if_discussion_is_past) }
    end

    it_behaves_like 'authenticate_user'

    before do
      @user = create(:user)
      sign_in @user
    end

    context 'event exists' do
      context 'discussion exists' do
        context 'discussion is upcoming' do
          before do
            @event = create(Event)
            user = double(User)
            @discussion = double(Discussion)
            expect(Event).to receive(:find_by).and_return(@event)
            expect(@event).to receive(:discussions).and_return(@discussion)
            expect(@discussion).to receive(:find_by).and_return(@discussion)
            expect(@discussion).to receive(:speaker=).and_return(user)
            expect(@discussion).to receive(:upcoming?).and_return(true)
          end
          context 'updated discussion is valid' do
            before do
              expect(@discussion).to receive(:update).and_return(@discussion)
            end
            it 'should redirect to the event show page' do
              send_request
              is_expected.to redirect_to(@event)
              is_expected.to set_flash[:success]
            end
          end
          context 'updated discussion is invalid' do
            before do
              expect(@discussion).to receive(:update).and_return(false)
            end
            it 'should render edit template' do
              send_request
              is_expected.to render_template(:edit)
              is_expected.to set_flash.now[:error]
            end
          end
        end
        context 'discussion is not upcoming' do
          before do
            @event = create(Event)
            user = double(User)
            discussion = double(Discussion)
            expect(Event).to receive(:find_by).and_return(@event)
            expect(@event).to receive(:discussions).and_return(discussion)
            expect(discussion).to receive(:find_by).and_return(discussion)
            expect(discussion).to receive(:upcoming?).and_return(false)
          end
          it 'should redirect to event path' do
            send_request
            is_expected.to redirect_to(event_path)
            is_expected.to set_flash[:notice]
          end
        end
      end
      context 'discussion doesnt exist' do
        before do
          event = double(Event)
          discussion = double(Discussion)
          expect(Event).to receive(:find_by).and_return(event)
          expect(event).to receive(:discussions).and_return(discussion)
          expect(discussion).to receive(:find_by).and_return(nil)
        end
        it 'should redirect to event discussions path' do
          send_request
          is_expected.to redirect_to(event_discussions_path)
          is_expected.to set_flash[:alert]
        end
      end
    end

    context 'event doesnt exists' do
      before do
        expect(Event).to receive(:find_by).and_return(nil)
      end
      it 'should redirect to events path' do
        send_request
        is_expected.to redirect_to(events_path)
        is_expected.to set_flash[:alert]
      end
    end
  end

end
