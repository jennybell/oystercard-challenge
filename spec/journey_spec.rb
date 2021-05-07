require 'journey'

describe Journey do
   let(:entry_station) { double("Station", :name => "Finsbury Park") }
   let(:exit_station) { double("Station", :name => "Bethnal Green") }
  
   it 'should store entry station when initialized' do
    journey = Journey.new(entry_station)
    expect(journey.entry_station).to eq(entry_station)
  end

  it 'should store exit station when journey ends' do
    journey = Journey.new(entry_station)
    journey.end(exit_station)
    expect(journey.exit_station).to eq(exit_station)
  end

  it 'should determine whether a journey is complete' do
    journey = Journey.new(entry_station)
    journey.end(exit_station)
    expect(journey.complete?).to be true
  end

  it 'should determine whether a journey is incomplete' do
    journey = Journey.new(entry_station)
    expect(journey.complete?).to be false
  end

  it 'returns the minimum fare when a journey is complete' do
    journey = Journey.new(entry_station)
    journey.end(exit_station)
    expect(journey.fare).to eq(Journey::MINIMUM_FARE)
  end

  it 'returns penalty fare when the journey is incomplete' do
    journey = Journey.new(entry_station)
    expect(journey.fare).to eq(Journey::PENALTY_FARE)
  end

end