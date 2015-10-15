require_relative '../rails_helper.rb'

describe UserMailer do
  describe '#reminder_email' do
    before do
      @discussion = double(Discussion, name: 'Discussion', location: 'L')
      @event = double(Event)
      @address = double(Address)
      @user = double(User, email: 'temp@example.com', title: 'Mr', name: 'Darcy')
      #SPEC cannot set address values in double but can set event
      @discussion.stub(:event).and_return(@event)
      @event.stub(:address).and_return(@address)
      @address.stub(:city).and_return('C')
      @address.stub(:country).and_return('C')
      @mail = UserMailer.reminder_email(@discussion, @user)
      @mail.deliver_now
    end

    it 'renders the subject' do
      expect(@mail.subject).to eq('Discussion Commencement Reminder')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql([DEFAULT_EMAIL])
    end

    it 'should send an email' do
      ActionMailer::Base.deliveries.count.should == 1
    end

  end

  describe '#discussion_disable_email' do
    before do
      @discussion = double(Discussion, name: 'Discussion', location: 'L', topic: 'T')
      @event = double(Event, name: 'Event')
      @address = double(Address)
      @user = double(User, email: 'temp@example.com', title: 'Mr', name: 'Darcy')
      @discussion.stub(:event).and_return(@event)
      time = Time.now
      @discussion.stub(:start_time).and_return(time)
      @discussion.stub(:end_time).and_return(time)
      @discussion.stub(:date).and_return(time)
      @mail = UserMailer.discussion_disable_email(@user, @discussion)
      @mail.deliver_now
    end

    it 'renders the subject' do
      expect(@mail.subject).to eq('Discussion Cancellation Notification')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql([DEFAULT_EMAIL])
    end

    it 'should send an email' do
      ActionMailer::Base.deliveries.count.should == 1
    end

  end

end
