class CreateUserJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_jobs do |t|
      t.integer :user_id
      t.integer :job_id

      t.timestamps
    end
  end
end
