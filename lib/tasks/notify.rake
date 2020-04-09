namespace :notify do
  task :user => :environment do
    notify_user = NotifyUser.new
    notify_user.message
  end
end