class CustomAuthenticationFailure < Devise::FailureApp 
  protected 
  # ログインしていない場合ルーとパスに飛ばすための記述
    def redirect_url
      new_user_session_path #roginに飛ばす場合
  #    root_path+"users/auth/facebook" #自動でfacebook認証させる場合
    end 
  end