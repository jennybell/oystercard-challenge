require 'oystercard'

describe Oystercard do
  let(:entry_station) { double("Station", :name => "Finsbury Park") }
  let(:exit_station) { double("Station", :name => "Bethnal Green") }
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }

  describe '.new' do
    it 'checks that default balance is zero' do
      expect(subject.balance).to eq (0)
    end
    it 'checks journey log is empty by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it 'can add to the balance' do
      #subject.top_up(5)
      #expect(subject.balance).to eq(5)
      expect{ subject.top_up(5) }.to change{ subject.balance }.by 5
    end
    it 'raises error when balance is over 90' do
      expect{ subject.top_up(91) }.to raise_error "Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded"
    end
  end

  describe '#touch_in' do
    it 'sets in_journey to true' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      expect(subject.in_journey?).to eq (true)
    end
    it 'raises an error when touching in with insufficient balance' do
      expect{ subject.touch_in(entry_station) }.to raise_error "Insufficent balance"
    end
    it 'saves entry_station on touch_in' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      expect(subject.current_journey.entry_station).to eq(entry_station)
    end
    it 'deducts the penalty fare when not touched out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE) 
      subject.touch_in(entry_station)
      expect { subject.touch_in(entry_station) }.to change{ subject.balance }.by(-Oystercard::PENALTY_FARE)
    end
  end

  describe '#touch_out' do
    it 'touches out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to eq (false)
    end
    it 'deducts from the balance on touch out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_BALANCE)
    end
    it 'completes the journey' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to be false
    end
    it 'saves exit_station on touch_out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.current_journey.exit_station).to eq(exit_station)
    end
    it 'deducts the penalty fare when not touched in' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::PENALTY_FARE)
    end
  end

  it 'stores journey' do
    subject.top_up(Oystercard::MAXIMUM_BALANCE)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys.include?(journey)).to eq(true)
  end

end