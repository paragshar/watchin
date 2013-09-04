class Channel < ActiveRecord::Base
  has_many :programmes
  has_many :messages
 
  has_attached_file :image, :url => "/system/channels/:attachment/:id/:style/:basename.:extension",
 :path =>":rails_root/public/system/channels/:attachment/:id/:style/:basename.:extension", :default_url => "/system/channels/missing.png"  
 
  # attr_accessible :name
  validates_presence_of :name
  validates :name, :length => { :minimum => 3}
  validates :name, :uniqueness => true
  
  def image_url
      image.url
  end
  
  
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :name,           :index    => :not_analyzed
    
  end
  
  
end
