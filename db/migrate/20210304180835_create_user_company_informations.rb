class CreateUserCompanyInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_company_informations do |t|
      t.string :website
      t.text :notes
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end
  end
end
