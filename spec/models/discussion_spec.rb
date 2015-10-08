require_relative '../rails_helper.rb'

describe Discussion do

  let(:discussion) { build(:discussion) }

  describe 'Fields' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:topic).of_type(:string) }
    it { is_expected.to have_db_column(:date).of_type(:date) }
    it { is_expected.to have_db_column(:start_time).of_type(:time) }
    it { is_expected.to have_db_column(:end_time).of_type(:time) }
    it { is_expected.to have_db_column(:location).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:enabled).of_type(:boolean) }
    it { is_expected.to have_db_column(:creator_id).of_type(:integer) }
    it { is_expected.to have_db_column(:event_id).of_type(:integer) }
    it { is_expected.to have_db_column(:speaker_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:creator).class_name('User') }
    it { is_expected.to belong_to(:speaker).class_name('User') }
    it { is_expected.to belong_to(:event) }
    it { is_expected.to have_many(:discussions_users).dependent(:destroy) }
    it { is_expected.to have_many(:attendees).through(:discussions_users) }
  end

  # describe 'Accepts Nested Attributes' do
  #   it { is_expected.to accept_nested_attributes_for(:address) }
  #   it { is_expected.to accept_nested_attributes_for(:contact_detail) }
  #   it { is_expected.to accept_nested_attributes_for(:discussions).but_reject(name: '', topic: '', location: '', speaker: '') }
  # end

  # describe 'Validations' do
  #   it { is_expected.to validate_presence_of :name }
  #   it { is_expected.to validate_presence_of :description }
  #   it { is_expected.to validate_presence_of :start_time }
  #   it { is_expected.to validate_presence_of :end_time }
  #   it { is_expected.to validate_inclusion_of(:enabled).in_array([true, false]) }
  #   it { is_expected.to allow_value(false).for(:enabled) }
  #   it { is_expected.not_to allow_value(nil).for(:enabled) }
  #   it { is_expected.to validate_length_of(:description).is_at_most(500).is_at_least(50) }

  #   describe 'Custom Validations' do
  #     context 'start time' do
  #       context 'should raise error if start time before current time' do
  #         before do
  #           event.start_time = Time.current - 1.day
  #         end
  #         it { expect(event.valid?).to eq(false) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:start_time]).to eq(['cannot be in the past']) }
  #         end
  #       end

  #       context 'should raise error if start time is equal to current time' do
  #         before { event.start_time = Time.current }
  #         it { expect(event.valid?).to eq(false) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:start_time]).to eq(['cannot be in the past']) }
  #         end
  #       end

  #       context 'should not raise error if start time after current time' do
  #         before { event.start_time = Time.current + 1.day }
  #         it { expect(event.valid?).to eq(true) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:start_time]).to eq([]) }
  #         end
  #       end
  #     end

  #     context 'end time' do
  #       context 'should raise error if end time before start time' do
  #         before do
  #           event.start_time = Time.current + 1.day
  #           event.end_time = Time.current
  #         end
  #         it { expect(event.valid?).to eq(false) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:end_time]).to eq(['must be later than start time']) }
  #         end
  #       end

  #       context 'should raise error if end time equal to start time' do
  #         let(:time) { Time.current }
  #         before { event.start_time = event.end_time = time }
  #         it { expect(event.valid?).to eq(false) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:end_time]).to eq(['must be later than start time']) }
  #         end
  #       end

  #       context 'should not raise error if end time after start time' do
  #         before do
  #           event.start_time = Time.current + 1.day
  #           event.end_time = Time.current + 2.days
  #         end
  #         it { expect(event.valid?).to eq(true) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:end_time]).to eq([]) }
  #         end
  #       end
  #     end

  #     context 'creator' do
  #       context 'should raise error if event is changed while creator is disabled' do
  #         before do
  #           event.creator.enabled = false
  #           event.save
  #         end
  #         it { expect(event.valid?).to eq(false) }
  #         context 'check errors' do
  #           before { event.valid? }
  #           it { expect(event.errors[:base]).to eq(['cannot be enabled']) }
  #         end
  #       end
  #     end #Context creator ends
  #   end #Context custom validations end
  # end #Context validations end

  # describe 'Scopes' do

  #   describe 'Enabled' do
  #     let!(:event1) { create(:event, enabled: true) }
  #     let!(:event2) { create(:event, enabled: false) }
  #     it { expect(Event.enabled).to match_array([event1]) }
  #   end

  #   describe 'Enabled with enabled creator' do
  #     let!(:event1) { create(:event, enabled: true) }
  #     let!(:event2) { create(:event, enabled: false) }
  #     let!(:event3) { create(:event, enabled: true) }
  #     let!(:event4) { create(:event, enabled: true) }
  #     before do
  #       event3.creator.enabled = false
  #       event3.creator.save
  #     end
  #     it { expect(Event.enabled_with_enabled_creator).to match_array([event1, event4]) }
  #     it { expect(Event.enabled_with_enabled_creator).not_to match_array([event2, event3]) }
  #   end

  #   describe 'Forthcoming' do
  #     let(:event1) { build(:event, start_time: Time.now - 1.day) }
  #     let(:event2) { build(:event, start_time: Time.now) }
  #     let(:event3) { build(:event, start_time: Time.now + 1.day) }
  #     before do
  #       event1.save(validate: false)
  #       event2.save(validate: false)
  #       event3.save(validate: false)
  #     end
  #     it { expect(Event.forthcoming).to match_array([event3]) }
  #   end
  # end

  # describe '#upcoming?' do
  #   context 'should return false if event start time is less than current time' do
  #     before { event.start_time = Time.current - 1.day }
  #     it { expect(event.upcoming?).to eq(false) }
  #   end

  #   context 'should return false if event start time is equal to current time' do
  #     before { event.start_time = Time.current }
  #     it { expect(event.upcoming?).to eq(false) }
  #   end

  #   context 'should return true if event start time is greater than current time' do
  #     before { event.start_time = Time.current + 1.day }
  #     it { expect(event.upcoming?).to eq(true) }
  #   end
  # end

  # describe '#live?' do
  #   context 'should return true if event time is ongoing' do
  #     before { event.start_time = Time.current - 1.day }
  #     before { event.end_time = Time.current + 1.day }
  #     it { expect(event.live?).to eq(true) }
  #   end

  #   context 'should return false if event time is not ongoing' do
  #     before { event.start_time = Time.current + 1.day }
  #     before { event.end_time = Time.current + 2.day }
  #     it { expect(event.live?).to eq(false) }
  #   end
  # end

end
