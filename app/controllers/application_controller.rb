class ApplicationController < ActionController::Base
	# before_actionはすべてのコントローラ実行する際に最初に行われる
	# デバイスのコントローラー用
	before_action :configure_permitted_parameters, if: :devise_controller?

	# ログイン後にマイページに飛ぶ
	def after_sign_in_path_for(resource)
   		user_url(resource)
 	end

 	# サインアップ時に保存するカラムを追加する
	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :postcode, :prefecture_name, :address_city, :address_street])
	end
	# データ更新時のパラメーターを設定する
	def configure_account_update_params
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :postcode, :prefecture_name, :address_city, :address_street])
    end
end
