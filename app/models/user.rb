class User < ActiveRecord::Base
  attr_accessible :email, :fullname, :password, :password_confirmation

  validates_presence_of :email, :password
  validates :email, :uniqueness => true
  validates :password, :confirmation => true
  validates :password, :length => { :in => 6..32 }

  has_many :events
  has_many :comments   

  require 'digest/md5'

  before_save do
    unless password_confirmation.nil?      
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end

  def self.auth(auth_email, auth_password)
    find_by_email_and_password(auth_email, Digest::MD5.hexdigest(auth_password))
  end

  def name
    fullname.empty? ? email : fullname
  end
end
