require_relative '../rails_helper.rb'
require_relative '../current_user_shared'

describe ApplicationController do

  it_behaves_like 'current_user'

  describe 'Callbacks' do
    it { is_expected.to use_before_action(:authenticate_user!) }
  end

  describe '#after_sign_in_path_for' do
    context 'should redirect to admin events path if user is an admin' do
      before do
        @admin = create(:admin)
        sign_in @admin
      end
      it { expect(controller.after_sign_in_path_for(@admin)).to eq(admin_events_path) }
    end
    context 'should redirect to root path if user is not an admin' do
      before do
        @user = create(:user)
        sign_in @user
      end
      it { expect(controller.after_sign_in_path_for(@user)).to eq(root_path) }
    end
  end


end
