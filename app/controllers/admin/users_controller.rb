class Admin::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :if_not_admin
  before_action :set_user, only: [:edit, :show, :update, :destroy]

  def index
      @users=User.select(:id,:name,:admin,)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path(@user.id), notice: "新規登録しました！"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path,notice:"#{@user.name}を編集しました"
    else
      # modelのerrorsをよびだしている
      @user.errors[:admin]
      render :edit
    end
  end

  def show
    @tasks= @user.tasks
  end

  def destroy
    if  @user.destroy
      redirect_to admin_users_path, notice:"削除しました"
    else
      redirect_to admin_users_path, notice:"管理者が0人になるので削除できません"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def if_not_admin
      redirect_to tasks_path, notice: '管理者のみアクセスできます' unless current_user.admin?
  end

end
