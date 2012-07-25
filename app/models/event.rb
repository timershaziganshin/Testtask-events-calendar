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
end
