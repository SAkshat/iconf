require_relative '../rails_helper.rb'

describe User do

  let(:user) { build(:user) }

  describe 'Fields' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:image_path).of_type(:string) }
    it { is_expected.to have_db_column(:nickname).of_type(:string) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:twitter_url).of_type(:string) }
    it { is_expected.to have_db_column(:enabled).of_type(:boolean) }
    it { is_expected.to have_db_column(:admin).of_type(:boolean) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:events).dependent(:destroy) }
    it { is_expected.to have_many(:discussions_users).dependent(:destroy) }
    it { is_expected.to have_many(:discussions).through(:discussions_users) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :title }
  end

  describe 'Scopes' do
    describe 'Enabled' do
      let!(:user1) { create(:user, enabled: true) }
      let!(:user2) { create(:user, enabled: false) }
      it { expect(User.enabled).to match_array([user1]) }
      it { expect(User.enabled).not_to match_array([user2]) }
    end
  end

  describe '#find_or_create_from_twitter_params' do
    context 'should create a user if no user exists with the given uid' do
      let(:params) { { uid: 10, info: { urls: {} } } }
      it { expect{ User.find_or_create_from_twitter_params(params) }.to change{ User.count }.by(1) }
    end
    context 'should not create a user if a user exists with the given uid' do
      let(:params) { { uid: 10, info: { urls: {} } } }
      before { User.find_or_create_from_twitter_params(params) }
      it { expect{ User.find_or_create_from_twitter_params(params) }.to change{ User.count }.by(0) }
    end
  end

end
