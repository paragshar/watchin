class AddPhotoTimestampToUser < ActiveRecord::Migration
  def change
    add_column :users, :photo_updated_at, :datetime
  end
end
