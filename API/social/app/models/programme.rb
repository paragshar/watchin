class Programme < ActiveRecord::Base
  has_many :messages
  belongs_to :channel
  attr_accessible :channel_id, :name
  validates_presence_of :name
  validates :name, :length => { :minimum => 3}
  validates :name, :uniqueness => true
end
