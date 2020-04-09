class MessagesController < ApplicationController
	  before_action :authenticate_user!, :only => [:create]

  def create
  	@new_book = Book.new
    # Entryモデルのuser_idからcurrent_user.idとroom_idがあるかどうか探す
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      redirect_to "/rooms/#{@message.room_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
