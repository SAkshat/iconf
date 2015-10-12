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

  describe 'Validations' do
    subject { build(:discussion) }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :topic }
    it { is_expected.to validate_presence_of :location }
    it { is_expected.to validate_presence_of(:speaker).with_message('does not have a valid email id') }
    it { is_expected.to validate_inclusion_of(:enabled).in_array([true, false]) }
    it { is_expected.to validate_length_of(:description).is_at_most(250).is_at_least(50) }

    describe 'Custom Validations' do
      context 'start time' do
        context 'should raise error if start time before current time' do
          before { discussion.start_time = Time.now - 1.day }
          it { expect(discussion.valid?).to eq(false) }
          context 'check errors' do
            before { discussion.valid? }
            it { expect(discussion.errors[:start_time]).to eq(['cannot be in the past']) }
          end
        end

        context 'should raise error if start time is equal to current time' do
          before { discussion.start_time = Time.now }
          it { expect(discussion.valid?).to eq(false) }
          context 'check errors' do
            before { discussion.valid? }
            it { expect(discussion.errors[:start_time]).to eq(['cannot be in the past']) }
          end
        end

        context 'should not raise start_time error if start time after current time' do
          before { discussion.start_time = Time.now + 1.day }
          context 'check errors' do
            before { discussion.valid? }
            it { expect(discussion.errors[:start_time]).to eq([]) }
          end
        end
      end

      context 'end time' do
        context 'should raise error if end time before start time' do
          before do
            discussion.start_time = Time.current + 1.day
            discussion.end_time = Time.current
          end
          it { expect(discussion.valid?).to eq(false) }
          context 'check errors' do
            before { discussion.valid? }
            it { expect(discussion.errors[:end_time]).to eq(['should be more than start time']) }
          end
        end

        context 'should raise error if end time equal to start time' do
          let(:time) { Time.current }
          before { discussion.start_time = discussion.end_time = time }
          it { expect(discussion.valid?).to eq(false) }
          context 'check errors' do
            before { discussion.valid? }
            it { expect(discussion.errors[:end_time]).to eq(['should be more than start time']) }
          end
        end

        context 'should not raise end-time error if end time after start time' do
          before do
            discussion.start_time = Time.current + 1.day
            discussion.end_time = Time.current + 2.days
          end
          context 'check errors' do
            before { discussion.valid? }
            it { expect(discussion.errors[:end_time]).to eq([]) }
          end
        end
      end

      context 'discussion timings' do
        context 'should raise error if discussion date is before event date' do
          before do
            discussion.event.start_time = Time.now
            discussion.date = Time.now - 1.day
            @start_time = discussion.event.start_time
            @end_time = discussion.event.end_time
            discussion.valid?
          end
          it { expect(discussion.errors[:date]).to eq(["must be within the event duration [#{ @start_time.to_date } -- #{ @end_time.to_date }]"]) }
        end
        context 'should raise error if discussion date is after event date' do
          before do
            discussion.event.end_time = Time.now
            discussion.date = Time.now + 1.day
            @start_time = discussion.event.start_time
            @end_time = discussion.event.end_time
            discussion.valid?
          end
          it { expect(discussion.errors[:date]).to eq(["must be within the event duration [#{ @start_time.to_date } -- #{ @end_time.to_date }]"]) }
        end
        context 'should not raise error if discussion date is between event date' do
          before do
            discussion.event.start_time = Time.now
            discussion.event.end_time = Time.now + 3.day
            discussion.date = Time.now + 1.day
            @start_time = discussion.event.start_time
            @end_time = discussion.event.end_time
            discussion.valid?
          end
          it { expect(discussion.errors[:date]).to eq([]) }
        end
      end
    end
  end

  describe 'Scopes' do
    describe 'Enabled' do
      let!(:discussion1) { create(:discussion, enabled: true) }
      let!(:discussion2) { create(:discussion, enabled: false) }
      it { expect(Discussion.enabled).to match_array([discussion1]) }
      it { expect(Discussion.enabled).not_to match_array([discussion2]) }
    end
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:send_disable_notification_email_to_attendees).after(:commit).if(:was_disabled?) }
  end


  describe '#upcoming?' do
    context 'should return false if discussion date is less than current date' do
      before { discussion.date = Time.now - 1.day }
      it { expect(discussion.upcoming?).to eq(false) }
    end

    context 'should return false if discussion start time is less than current time and date is equal to current date' do
      before do
        discussion.date = Time.now
        discussion.start_time = Time.now - 1.hour
      end
      it { expect(discussion.upcoming?).to eq(false) }
    end

    context 'should return false if discussion start time is equal to current time and date is equal to current date' do
      before do
        discussion.date = Time.now
        discussion.start_time = Time.now
      end

      it { expect(discussion.upcoming?).to eq(false) }
    end

    context 'should return true if discussion start time is greater than current time and date is equal to current date' do
      before do
        discussion.date = Time.now
        discussion.start_time = Time.now + 1.hour
      end
      it { expect(discussion.upcoming?).to eq(true) }
    end

    context 'should return true if discussion date is more than current date' do
      before { discussion.date = Time.now + 1.day }
      it { expect(discussion.upcoming?).to eq(true) }
    end
  end

  describe '#was_disabled?' do
    context 'should return true if discussions enabled status changes from true to false' do
      before do
        discussion.enabled = true
        discussion.save
        discussion.enabled = false
      end
      it { expect(discussion.send(:was_disabled?)).to eq(true) }
    end
    context 'should return false if discussions enabled status changes from false to true' do
      before do
        discussion.enabled = false
        discussion.save
        discussion.enabled = true
      end
      it { expect(discussion.send(:was_disabled?)).to eq(false) }
    end
    context 'should return false if discussions enabled status changes from false to false' do
      before do
        discussion.enabled = false
        discussion.save
        discussion.enabled = false
      end
      it { expect(discussion.send(:was_disabled?)).to eq(false) }
    end
    context 'should return false if discussions enabled status changes from true to true' do
      before do
        discussion.enabled = true
        discussion.save
        discussion.enabled = true
      end
      it { expect(discussion.send(:was_disabled?)).to eq(false) }
    end
  end

  describe '#send_disable_notification_email_to_attendees' do
    context 'should send email to all attendees of the discussion when invoked' do
      before do
        @count = discussion.attendees.count
      end
      it { expect{ discussion.send(:send_disable_notification_email_to_attendees)}.to change{ ActionMailer::Base.deliveries.count }.by(@count) }
    end
  end

end
