# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# wrapping for ERD generation (normal command `bundle exec erd`) - also opens files after generation
desc "Generate ERD" 
task :erd => :environment do
  Rake::Task[:erd_generate].invoke
end

task :erd_generate => ["erd:check_dependencies", "erd:options"] do
  `cmd.exe /C start erd.pdf`
end

# reset database - drop, migrate, seed
task :resetdb do
  Rake::Task["db:drop"].execute
  Rake::Task["db:create"].execute
  Rake::Task["db:migrate"].execute 
  Rake::Task["db:seed"].execute 
end
