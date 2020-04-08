class BookCommentsController < ApplicationController
	def create
		# コメント削除
		book = Book.find(params[:book_id])
		@comment = current_user.book_comments.new(book_comment_params)
		# comment = PostComment.new(post_comment_params)
		# comment.user_id = current_user.id
		# 下の一行は上記に行と同じ意味
		@comment.book_id = book.id
		@comment.save
		redirect_to book_path(book)
	end


	def destroy
        @comment = BookComment.find_by(id: params[:id],book_id: params[:book_id])
        @comment.destroy
        redirect_to book_path(@comment.book_id),notice: "コメント1件削除しました"
	end

	private
	def book_comment_params
		params.require(:book_comment).permit(:comment, :book_id, :user_id)
	end
end
