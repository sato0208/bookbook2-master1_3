class UsersController < ApplicationController
# authenticate_user！でログイン認証されてない場合home画面へリダイレクトとする
  before_action :authenticate_user!
  # カレントユーザーだけしかedit,update,destroyアクションは使えない。
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  # ※カレントユーザー以外は直接リンクを入力しても編集ページにいけないようにする
def ensure_correct_user
  @user = User.find(params[:id])
  # ※カレントユーザーIDがbook.user_idと同じでない場合はbooks_pathへ飛ばす
  @user_profire = current_user
  if current_user.id != @user.id
    redirect_to user_path(@user_profire)
  end
end

# 検索用
def search
  @new_book = Book.new
  @user_profire = current_user
  @how_search = params[:choice]
  @user_or_book = params[:option]
  if @user_or_book == "1"
    @users = User.search(params[:search], @user_or_book, @how_search)
  else
    @books = Book.search(params[:search], @user_or_book, @how_search)
  end
end

def show
  @comment = User.find(params[:id]).book_comments
  @user = User.find(params[:id])
  # Userテーブルからユーザデータを取り出してそれに紐づく内容をbooksとして表示する
  @user_books = User.find(params[:id]).books
  @new_book = Book.new
  @user_profire = current_user

  @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

def edit
  # ユーザ情報を取得してインスタンス@userに保存し、編集用viewでform_forを使う準備
  @user = User.find(params[:id])
  @book = Book.new
end

def update
 @user = User.find(params[:id])
 if @user.update(user_params)
   redirect_to user_path(@user.id), alert: 'Signed in successfully.'
 else render :edit
 end
end

def index
  @users = User.all
  @new_book = Book.new
  @user_profire = current_user
end

def destroy
  reset_session
  redirect_to root_path, alert: "Signed out successfully."
end

def following
  @user = User.find(params[:id])
  @users = @user.followings
  render 'show_follow'
end

def follower
  @user = User.find(params[:id])
  @users = @user.followers
  render 'show_follower'
end

private
# 名前とプロフィールイメージがきちんと入っているかチェックする
def user_params
	params.require(:user).permit(:name, :profile_image, :introduction, :postcode, :prefecture_name, :address_city, :address_street, :address_building,:latitude, :longitude)
end


end