class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.bigint :remote_id, null: false
      t.text :text, null: false
      t.datetime :published_at, null: false

      t.timestamps
    end

    add_index :tweets, :remote_id, unique: true
  end
end
