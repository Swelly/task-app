class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name
  validates_presence_of :interval
  validates_presence_of :interval_number
  validates_inclusion_of :interval_type, in: %w[days weeks months]

  def self.make(user_id, params)
    task = Task.new(params)
    task.user_id = user_id
    task.interval = calculate_interval(params[:interval_number].to_i, params[:interval_type])
    task.save
    task
  end

  def self.find_and_update(id, params)
    task = find(id)
    if params[:interval_number] && params[:interval_type]
      params[:interval] = calculate_interval(params[:interval_number].to_i, params[:interval_type])
    end
    task.update(params)
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
