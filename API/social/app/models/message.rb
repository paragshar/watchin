class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  belongs_to :programme
  attr_accessible :message, :view_ability, :channel_id, :user_id, :programme_id
  validates_presence_of :message, :channel_id, :programme_id, :view_ability
end
