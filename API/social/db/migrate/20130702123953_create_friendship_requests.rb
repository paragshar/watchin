class CreateFriendshipRequests < ActiveRecord::Migration
  def change
    create_table :friendship_requests do |t|
      t.integer :user_id
      t.integer :friend_id

      t.timestamps
    end
  end
end
