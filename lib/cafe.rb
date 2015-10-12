module Cafe
  def self.open?
    now = Time.now

    # If it is not a weekday the cafe is not open
    return false if !WEEKDAYS.include?(now.wday)

    # Otherwise return whether or not the current time is between open and close
    hours = Range.new(
      Time.local(now.year, now.month, now.day, OPEN_HOUR, OPEN_MINUTE).to_i,
      Time.local(now.year, now.month, now.day, CLOSE_HOUR, CLOSE_MINUTE).to_i
    )
    hours.include?(now.to_i)
  end

  private

  CLOSE_HOUR = 16
  CLOSE_MINUTE = 30
  OPEN_HOUR = 7
  OPEN_MINUTE = 30
  WEEKDAYS = 1..5 # 1 = Monday, 5 = Friday
end

