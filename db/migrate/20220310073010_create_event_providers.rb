class CreateEventProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :event_providers do |t|
      t.string :refresh_token
      t.string :access_token

      t.timestamps
    end
  end
end
