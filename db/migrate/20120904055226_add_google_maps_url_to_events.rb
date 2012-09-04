class AddGoogleMapsUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :google_maps_url, :string
  end
end
