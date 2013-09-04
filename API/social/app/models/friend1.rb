class Friend < ActiveRecord::Base
  belongs_to :user
  attr_accessible :friend_id, :user_id, :name
  validate :cannot_add_self

  def cannot_add_self
    errors[:base] <<'You cannot add yourself as a friend.' if self.user_id == self.friend_id
  end
end
