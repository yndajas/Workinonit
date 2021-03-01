class CreateProviderCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :provider_countries do |t|
      t.integer :provider_id
      t.integer :country_id
      t.string :code

      t.timestamps
    end
  end
end
