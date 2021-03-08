# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: "test@g.co", password: "test", name: "Testy McTestface")

deletable_user = User.create(email: "delete-me@g.co", password: "test", name: "Deletey")
company = Company.create(name: "Wurky placeSA")
deletable_job = Job.create(title: "test job title JOJPKW", company_id: company.id)
undeletable_job = Job.create(title: "great job security for WEWEKLJ", company_id: company.id, provider_id: 1)
deletable_user_job_for_deletable_job = UserJob.create(user_id: deletable_user.id, job_id: deletable_job.id)
deletable_user_job_for_undeletable_job = UserJob.create(user_id: deletable_user.id, job_id: undeletable_job.id)
deletable_application_for_deletable_job = Application.create(user_id: deletable_user.id, job_id: deletable_job.id, status_id: 1)
deletable_application_for_undeletable_job = Application.create(user_id: deletable_user.id, job_id: undeletable_job.id, status_id: 1)
deletable_user_company_information = UserCompanyInformation.create(user_id: deletable_user.id, company_id: company.id)