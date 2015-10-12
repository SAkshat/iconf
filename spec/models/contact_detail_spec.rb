require_relative '../rails_helper.rb'

describe ContactDetail do

  let(:contact_detail) { build(:contact_detail) }

  describe 'Fields' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:phone_number).of_type(:string) }
    it { is_expected.to have_db_column(:contactable_id).of_type(:integer) }
    it { is_expected.to have_db_column(:contactable_type).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:contactable) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :phone_number }
  end

end
