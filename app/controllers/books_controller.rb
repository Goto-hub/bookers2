class BooksController < ApplicationController
   #アクセス制限
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def new
    @book = Book.new
  end
  
  # 投稿データの保存
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to books_path(:id)
    else
      flash[:alert] = "error:Failed to create. Fill in the blanks."
      render :new
    end
  end

  def index
    @books = Book.page(params[:page])
    @user = current_user
    @book = Book.new
  end

  def show
    @book = Book.new
    @books = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = current_user
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def destroy
    book = Book.find(params[:id])
    book.destroy
    flash[:notice] = "Book was successfully destroyed."
    redirect_to books_path
  end
  
  
  def update
    @book = Book.find(params[:id])
    if @book.update(list_params)
      # フラッシュメッセージを定義し、indexへリダイレクト
       flash[:notice] = "Book was successfully updated."
       redirect_to book_path(@book.id)  
    else
       flash[:alert] = "error:Failed to update. Fill in the blanks."
        render :edit
    end
    
    
  end
  
  
  # 投稿データのストロングパラメータ
  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
   # アクセス制限
  def is_matching_login_user
    user = Book.find(params[:user_id])
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
  
end
