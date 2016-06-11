class Visit < ActiveRecord::Migration

  def change
    create_table :visits do |t|
      t.uuid :visitor_id, default: nil
      t.string :ip
      t.string :browser
      t.string :os
      t.string :device_type
      t.integer :screen_height
      t.integer :screen_width
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign

      t.timestamp :started_at
    end

  end
end
