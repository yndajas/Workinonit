class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.integer :user_id
      t.integer :job_id
      t.boolean :checked_job_requirements
      t.boolean :researched_company
      t.boolean :made_contact
      t.boolean :prepared_cv
      t.boolean :prepared_cover_letter
      t.integer :status_id
      t.date :date_found
      t.date :date_applied
      t.date :interview_date
      t.date :date_outcome_received
      t.text :notes
      t.text :feedback

      t.timestamps
    end
  end
end
