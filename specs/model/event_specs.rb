describe Event, '.enabled' do
  it 'returns only enabled events' do
    enabled_event = create(:event, enabled: true)
    disabled_event = create(:event, enabled: false)

    result = Event.enabled

    expect(result).to eq [enabled_event]
  end
end
