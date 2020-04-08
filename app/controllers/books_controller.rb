# これはbooksコントローラー

class BooksController < ApplicationController

# authenticate_user！でログイン認証されてない場合home画面へリダイレクトとする
	before_action :authenticate_user!
	# カレントユーザーだけしかedit,update,destroyアクションは使えない。
	before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

# ※カレントユーザー以外は直接リンクを入力しても編集ページにいけないようにする
def ensure_correct_user
	@book = Book.find(params[:id])
	# ※カレントユーザーIDがbook.user_idと同じでない場合はbooks_pathへ飛ばす
	if current_user.id != @book.user_id
		flash[:notice] = "ページにアクセスする権限がありません"
		redirect_to(books_path)
	end
end

def new
	@book = Book.new(book_params)
end

# 投稿データの保存
def create
	# book_paramsで投稿データとして許可されているパラメーターかチェック
	@new_book = Book.new(book_params)
	# 今ログインしているユーザのIDをuser_idへ代入する。この項目を入力しないとviewへ送れない
	@new_book.user_id = current_user.id
	@books = Book.all
	@user_profire = current_user
	if @new_book.save
		redirect_to book_path(@new_book.id), notice:'You have creatad book successfully.'
	else
		render :index
	end
end

def index
	@new_book = Book.new
	@books = Book.all
	@user_profire = current_user
end

# 投稿データの詳細画面表示
def show
	@comments = Book.find(params[:id]).book_comments
	@new_book = Book.new
	@book = Book.find(params[:id])
	@user = Book.find(params[:id]).user
	@user_profire = current_user
	@comment = BookComment.new
end

# 投稿データの編集機能
def edit
	@book = Book.find(params[:id])
end

# 編集して登録する機能
def update
	@book = Book.find(params[:id])
	if @book.update(book_params)
		redirect_to book_path, notice:'You have updated book successfully.'
	else
		render :edit
	end
end

# 削除機能
def destroy
	@book = Book.find(params[:id])
	@book.destroy
	redirect_to books_path
end

# 投稿データのストロングパラメーター create、updateに渡す役割
private
def book_params
	params.require(:book).permit(:title, :body, :user_id)
end

end