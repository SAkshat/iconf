require_relative '../rails_helper.rb'

describe DiscussionsUser do

  let(:discussions_user) { build(:discussions_user) }

  describe 'Fields' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:discussion_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:discussion) }
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:queue_user_for_discussion_reminder).after(:create) }
    it { is_expected.to callback(:remove_user_from_discussion_reminder_queue).after(:destroy) }
  end

  describe '#queue_user_for_discussion_reminder' do
    context 'should queue a mail to be delivered' do
      before { discussions_user.save }
      it { expect{ discussions_user.send(:queue_user_for_discussion_reminder) }.to change{ Delayed::Job.count }.by(1) }
    end
  end

  describe '#remove_user_from_discussion_reminder_queue' do
    context 'should remove a queued mail from delayed jobs' do
      before do
        discussions_user.save
        discussions_user.send(:queue_user_for_discussion_reminder)
        discussions_user.delayed_job_id = Delayed::Job.last.id
      end
      it { expect{ discussions_user.send(:remove_user_from_discussion_reminder_queue) }.to change{ Delayed::Job.count }.by(-1) }
    end
  end
  #SPEC TIME SECONDS DIFFERENCE
  describe '#reminder_time' do
    context 'should return a datetime object with value as the start date-time of the object' do
      let(:time) { Time.now }
      before do
        discussions_user.discussion.date = time
        discussions_user.discussion.start_time = time
        @result = time.localtime('+00:00').to_datetime
      end
      it { expect(discussions_user.send(:reminder_time)).to eq(@result) }
    end
  end

end
