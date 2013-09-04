class AddImageToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :image_file_name, :string
    add_column :channels, :image_content_type, :string
    add_column :channels, :image_file_size, :integer
    add_column :channels, :image_updated_at, :datetime
  end
end
