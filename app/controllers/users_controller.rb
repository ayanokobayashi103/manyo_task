class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id), notice: "新規登録しました！"
    else
      render :new
    end
  end

  def show
    unless @user == current_user
      redirect_to tasks_path, notice: "エラー"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path,notice:"編集しました"
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
