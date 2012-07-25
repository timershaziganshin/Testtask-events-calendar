class User < ActiveRecord::Base
  attr_accessible :email, :fullname, :password, :password_confirmation

  validates_presence_of :email, :password
  validates :email, :uniqueness => true
  validates :password, :confirmation => true
  validates :password, :length => { :in => 6..32 }

  has_many :events
  has_many :comments   

  before_save do
    if !self.password_confirmation.nil?
      require 'digest/md5'

      self.password = Digest::MD5.hexdigest(self.password)
    end
  end

  def name
    fullname.empty? ? email : fullname
  end
end
