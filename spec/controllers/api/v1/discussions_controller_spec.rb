require_relative '../../../rails_helper.rb'

describe API::V1::DiscussionsController do

  describe 'Callbacks' do
    it { is_expected.to use_before_action(:load_discussion) }
  end

  context 'GET attendees' do
    def send_request(params={})
      get :attendees, params.merge({ discussion_id: 1 }), format: :json
    end

    context 'discussion doesnt exist' do
      before do
        Discussion.stub(:find_by).and_return(nil)
      end
      it do
        # expect(response.status).to eq(404)
        debugger
        expect(response.text).to eq("Discussion doesn't exist here")
      end
    end
  end
end
