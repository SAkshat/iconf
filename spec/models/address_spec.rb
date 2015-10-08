require_relative '../rails_helper.rb'

describe Address do

  let(:address) { build(:address) }

  describe 'Fields' do
    it { is_expected.to have_db_column(:street).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:country).of_type(:string) }
    it { is_expected.to have_db_column(:zipcode).of_type(:string) }
    it { is_expected.to have_db_column(:event_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:event) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :street }
    it { is_expected.to validate_presence_of :city }
    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_presence_of :zipcode }
    it { is_expected.to validate_length_of(:zipcode).is_equal_to(6) }
  end

end
