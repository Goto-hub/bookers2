class UsersController < ApplicationController
  
  #アクセス制限
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def index
    @users = User.page(params[:page])
    @user = current_user
    @books = @user.books.page(params[:page])
    @book = Book.new
  end
  
  def show
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page])
    @book = Book.new
  end
  
  def edit
    @user = User.find(params[:id])
    
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id) 
  end


private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
  
   # アクセス制限
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end
  
  
end
