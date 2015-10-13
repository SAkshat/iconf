require_relative '../../rails_helper.rb'
require_relative '../../current_user_shared'
require_relative '../../authenticate_admin_shared'

describe Admin::AdminController do

  it_behaves_like 'current_user'
  # it_behaves_like 'authenticate_admin'

  describe 'Callbacks' do
    it { is_expected.to use_before_action(:authenticate_admin) }
  end

end
