class Task < ActiveRecord::Base
  belongs_to :user

  attr_accessor :interval_number, :interval_type

  def self.make(user_id, params)
    task = Task.new(params)
    task.user_id = user_id
    task.save
    task
  end

  def self.calculate_interval(interval_number, interval_type)
    case interval_type
    when "days"
      seconds_multiplier = 86400 # 1 day (24 hrs * 60 min * 60 sec)
    when "weeks"
      seconds_multiplier = 604800 # 1 week (7 days * 24 hrs * 60 min * 60 sec)
    when "months"
      seconds_multiplier = 2592000 # 30 days (30 days * 24 hrs * 60 min * 60 sec)
    end
    interval_number * seconds_multiplier
  end
end
