require 'station'

describe Station do
  describe '.new' do
    let(:station) { Station.new("Finsbury Park", 1) }
    it 'has a name' do
      expect(station.name).to eq("Finsbury Park")
    end
    it 'has a zone' do 
      expect(station.zone).to eq(1)
    end
  end
end