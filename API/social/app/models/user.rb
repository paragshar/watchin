class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  before_save :ensure_authentication_token
# private
  # def generate_authentication_token
    # begin 
      # self.authentication_token = SecureRandom.hex
    # end while self.class.exists?(authentication_token: authentication_token)  
  # end   
  
  # has_many :friends, :foreign_key => "friend_id"
  has_many :friendships
  has_many :friends, :through => :friendships
  
  has_many :friendship_requests
  has_many :friends, :through => :friendship_requests
  
  has_many :inverse_friendship_requests, :class_name => "FriendshipRequest", :foreign_key => "friend_id"
  has_many :inverse_friend_requests, :through => :inverse_friendship_requests, :source => :user
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
  
  has_many :messages
  
  has_attached_file :photo, :url => "/system/users/:attachment/:id/:style/:basename.:extension",
 :path =>":rails_root/public/system/users/:attachment/:id/:style/:basename.:extension", :default_url => "/system/photos/missing.png"                    

  # Setup accessible (or protected) attributes for your model
  # attr_accessor :password, :password_confirmation, :current_password
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :authentication_token, :photo_file_name, :photo_content_type, :photo_file_size
  # attr_accessible :title, :body
  validates :name, presence: true
  
  def photo_url
      photo.url
  end
  def self.search(search)
    if search 
      find(:all, :conditions => ['name LIKE ? Or email LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
end
