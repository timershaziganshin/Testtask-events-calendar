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

  def self.events_at(search_date)
    result = []

    find_each { |event| result << event if event.takes_place_at?(search_date) }    

    result
  end

  def takes_place_at?(search_date)
    (date == search_date) || 
    (date < search_date) && 
    ((period == DAILY) ||
    (period == WEEKLY) && integer_weeks_to_date?(search_date) ||
    (period == MONTHLY) && integer_months_to_date?(search_date) ||
    (period == YEARLY) && integer_years_to_date?(search_date))    
  end

  private

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
