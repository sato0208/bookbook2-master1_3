namespace :user_mail do
  desc "user_mail_Submit"
  task :user :environment　do
    Usermailer.notify_user
  end
end