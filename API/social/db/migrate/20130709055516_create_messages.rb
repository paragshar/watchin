class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user
      t.references :channel
      t.references :programme
      t.string :view_ability
      t.text :message

      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :channel_id
    add_index :messages, :programme_id
  end
end
