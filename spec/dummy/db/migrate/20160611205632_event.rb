class Event < ActiveRecord::Migration

  def change
    create_table :ahoy_events do |t|
      t.integer :visit_id

      t.string :name
      t.jsonb :properties
      t.timestamp :time
    end
  end
end
