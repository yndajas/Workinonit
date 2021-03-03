class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :title
      t.integer :company_id
      t.string :location
      t.string :salary
      t.string :contract
      t.text :description
      t.string :provider_job_slug
      t.string :provider_job_id
      t.integer :provider_id
      t.integer :country_id

      t.timestamps
    end
  end
end
