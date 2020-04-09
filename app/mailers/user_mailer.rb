class UserMailer < ApplicationMailer
	def user_welcome_mail(user)
	    @user = user
		mail(to: @user.email, subject: 'Welcome to Bookers!yay!')
	end

	def notify_user(user)
		User.find_each do |user|
			UserMailer.with(user: user).UserMailer.deliver_now
		end
		mail(to: @user.email, subject: 'everyday Bookers!yay!')
	end
end