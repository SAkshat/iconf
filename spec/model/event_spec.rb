require_relative '../rails_helper.rb'
require_relative '../spec_helper.rb'

describe Event, type: :model do

  let(:event) { Event.new(name: "Event", description: 'lorem ipsum forum terlo merdensk estur silan pereditta', start_time: Time.now,
                            end_time: Time.now + 1.day, logo: "A", enabled: true, creator_id: 1) }

  describe "Fields" do
    it { expect(event).to have_db_column(:name).of_type(:string) }
    it { expect(event).to have_db_column(:start_time).of_type(:datetime) }
    it { expect(event).to have_db_column(:end_time).of_type(:datetime) }
    it { expect(event).to have_db_column(:description).of_type(:string) }
    it { expect(event).to have_db_column(:logo).of_type(:string) }
    it { expect(event).to have_db_column(:enabled).of_type(:boolean) }
    it { expect(event).to have_db_column(:creator_id).of_type(:integer) }
    it { expect(event).to have_db_column(:created_at).of_type(:datetime) }
    it { expect(event).to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:creator) }
    it { is_expected.to have_many(:discussions).dependent(:destroy) }
    it { is_expected.to have_one(:contact_detail).dependent(:destroy) }
    it { is_expected.to have_one(:address).dependent(:destroy) }
  end

  describe 'Accept Nested Attributes' do
    it { is_expected.to accept_nested_attributes_for(:address) }
    it { is_expected.to accept_nested_attributes_for(:contact_detail) }
  end

  describe 'Validations' do
    it { expect(event).to validate_presence_of(:name) }
    it { expect(event).to allow_value(true).for(:enabled) }
    it { expect(event).to allow_value(false).for(:enabled) }
    it { expect(event).not_to allow_value(nil).for(:enabled) }
    it { expect(event).to validate_length_of(:description).is_at_most(500).is_at_least(50) }
  end

  describe 'Enabled scope' do
    let(:event1) { Event.new(name: "Event1", description: 'lorem ipsum forum terlo merdensk estur silan pereditta', start_time: Time.now,
                            end_time: Time.now + 1.day, logo: "A", enabled: true, creator_id: 1) }
    let(:event2) { Event.new(name: "Event2", description: 'lorem ipsum forum terlo merdensk estur silan pereditta', start_time: Time.now,
                            end_time: Time.now + 1.day, logo: "A", enabled: false, creator_id: 1) }
    describe 'enabled' do
      before { [event1.save(validate: false), event2.save(validate: false)] }
      it { expect(Event.enabled).to match_array([event1]) }
    end
  end

end
