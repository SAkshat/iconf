require_relative '../rails_helper.rb'
require_relative '../current_user_shared'

describe DiscussionsUsersController do

  it_behaves_like 'current_user'
  before do
    @user = create(:user)
    sign_in @user
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
      context "it redirects to previous page" do
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:error] }
      end
    end

    context 'if user is unable to rsvp' do
      before do
        discussion = double(Discussion)
        discussions_user = double(DiscussionsUser)
        discussion.stub(:id).and_return(nil)
        Discussion.stub(:find_by).and_return(discussion)
        user = controller.current_user
        user.stub(:discussions_users).and_return(discussions_user)
        discussions_user.stub(:create).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
        send_request()
      end
      context "it redirects to previous page" do
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:error] }
      end
    end

    context 'if rsvp is successful' do
      before do
        discussion = double(Discussion)
        discussions_user = double(DiscussionsUser)
        discussion.stub(:id).and_return(1)
        Discussion.stub(:find_by).and_return(discussion)
        user = controller.current_user
        user.stub(:discussions_users).and_return(discussions_user)
        discussions_user.stub(:create).and_return(discussions_user)
        request.env['HTTP_REFERER'] = root_path
        send_request
      end
      context "it redirects to previous page" do
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:notice] }
      end
    end

  end

  describe 'POST destroy' do
    def send_request(params={id: 1})
      post :destroy, params
    end

    context 'if user hasnt rsvp-d' do
      before do
        discussion = double(Discussion)
        discussions_user = double(DiscussionsUser)
        user = controller.current_user
        user.stub(:discussions_users).and_return(discussions_user)
        discussions_user.stub(:find_by).and_return(nil)
        request.env['HTTP_REFERER'] = root_path
        send_request
      end
      context "it redirects to previous page" do
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:error] }
      end
    end

    context 'if user is unable to destroy his rsvp' do
      before do
        discussion = double(Discussion)
        discussions_user = double(DiscussionsUser)
        user = controller.current_user
        user.stub(:discussions_users).and_return(discussions_user)
        discussions_user.stub(:find_by).and_return(discussions_user)
        discussions_user.stub(:destroy).and_return(false)
        request.env['HTTP_REFERER'] = root_path
        send_request
      end
      context "it redirects to previous page" do
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:error] }
      end
    end

    context 'if destruction of rsvp is successful' do
      before do
        discussion = double(Discussion)
        discussions_user = double(DiscussionsUser)
        user = controller.current_user
        user.stub(:discussions_users).and_return(discussions_user)
        discussions_user.stub(:find_by).and_return(discussions_user)
        discussions_user.stub(:destroy).and_return(discussions_user)
        request.env['HTTP_REFERER'] = root_path
        send_request
      end
      context "it redirects to previous page" do
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:notice] }
      end
    end

  end

end
