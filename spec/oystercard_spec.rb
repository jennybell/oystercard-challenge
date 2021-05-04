require 'oystercard'

describe Oystercard do
  
  it 'checks that default balance is zero' do
    expect(subject.balance).to eq (0)
  end

  it 'can add to the balance' do
    #subject.top_up(5)
    #expect(subject.balance).to eq(5)
    expect{ subject.top_up(5) }.to change{ subject.balance }.by 5
  end

  it 'raises error when balance is over 90' do
    expect{ subject.top_up(91) }.to raise_error "Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded"
  end

end