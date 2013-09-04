class AddColToUser < ActiveRecord::Migration
  def change
    add_column :users, :currently_view_channel_id, :integer
  end
end
