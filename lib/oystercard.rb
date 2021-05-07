class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journeys, :current_journey

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  PENALTY_FARE = 6

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if (balance + amount) > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(entry_station)
    fail "Insufficent balance" if balance < MINIMUM_BALANCE
    if @current_journey
      deduct(PENALTY_FARE)
    else
      @current_journey = Journey.new(entry_station)
    end
  end

  def touch_out(exit_station)
    if @current_journey
      @current_journey.end(exit_station)
      deduct(@current_journey.fare)
      store_journey
    else
      deduct(PENALTY_FARE)      
    end
end

  def in_journey?
    !@current_journey.complete?
  end
  
  private

  def deduct(fare)
      @balance -= fare
  end

  def store_journey
    journeys << {entry_station: @current_journey.entry_station, exit_station: @current_journey.exit_station} 
  end

end