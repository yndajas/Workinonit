class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :base_show_url

      t.timestamps
    end

    Provider.create(name: "Indeed", base_show_url: "https://uk.indeed.com/viewjob?jk=")
    Provider.create(name: "LinkedIn", base_show_url: "https://www.linkedin.com/jobs/view/")
    Provider.create(name: "Reed", base_show_url: "https://www.reed.co.uk/jobs/")
  end
end
