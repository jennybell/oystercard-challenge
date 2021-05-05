require 'oystercard'

describe Oystercard do
  let(:entry_station) { double("Station", :name => "Finsbury Park") }
  describe '.new' do
    it 'checks that default balance is zero' do
      expect(subject.balance).to eq (0)
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
      expect(subject.in_journey).to eq (true)
    end
    it 'raises an error when touching in with insufficient balance' do
      expect{ subject.touch_in(entry_station) }.to raise_error "Insufficent balance"
    end
    it 'saves entry_station on touch_in' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq(entry_station)
    end
  end

  describe '#touch_out' do
    it 'touches out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      subject.touch_out
      expect(subject.in_journey).to eq (false)
    end
    it 'deducts from the balance on touch out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      expect { subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_BALANCE)
    end
    it 'sets entry_station to nill' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(entry_station)
      subject.touch_out
      expect(subject.entry_station).to eq(nil)
    end
  end
end