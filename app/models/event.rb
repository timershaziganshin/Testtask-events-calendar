class Event < ActiveRecord::Base
  NO_PERIOD = 0
  DAILY = 1
  WEEKLY = 2
  MONTHLY = 3
  YEARLY = 4

  attr_accessible :date, :name, :period

  validates_presence_of :date, :name
  validates :period, :inclusion => { :in => 0..4 }

  before_save do
    period = NO_PERIOD if period.nil?      
  end

  belongs_to :user
  has_many :comments

  scope :before_date_and_with_period, lambda { |search_date, period| where('date < ? and period = ?', search_date, period) }

  def self.events_at(search_date)
    result = where(:date => search_date)

    result += before_date_and_with_period(search_date, DAILY)
    result += before_date_and_with_period(search_date, WEEKLY).select { |event| event.integer_weeks_to_date?(search_date) }
    result += before_date_and_with_period(search_date, MONTHLY).select { |event| event.integer_months_to_date?(search_date) }
    result += before_date_and_with_period(search_date, YEARLY).select { |event| event.integer_years_to_date?(search_date) }

    result
  end

  def integer_weeks_to_date?(end_date)
    result = (end_date - date).to_f / 7.0

    result == result.floor
  end

  def integer_months_to_date?(end_date)
    result = (end_date.year - date.year) * 12 + end_date.month - date.month

    if (date.day <= Time.days_in_month(end_date.month, end_date.year)) || 
       (end_date.day < Time.days_in_month(end_date.month, end_date.year))    
      result += (end_date.day - date.day) / 31.0
    end

    result == result.floor
  end

  def integer_years_to_date?(end_date)
    result = end_date.year - date.year

    bool = (end_date.month != date.month) ||
       (end_date.day != date.day) && ((end_date.month != 2) || Date.gregorian_leap?(end_date.year) || (date.day != 29) || (end_date.day != 28))             

    !bool
  end
end
