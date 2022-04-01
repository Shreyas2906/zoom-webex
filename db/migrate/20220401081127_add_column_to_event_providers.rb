class AddColumnToEventProviders < ActiveRecord::Migration[6.0]
  def change
    add_column :event_providers, :web_refresh_token, :string
    add_column :event_providers, :web_access_token, :string
  end
end
