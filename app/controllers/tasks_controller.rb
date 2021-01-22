class TasksController < ApplicationController
  before_action :basic_auth, if: :production?
  before_action :authenticate_user
  before_action :set_task, only: [:edit, :show, :update, :destroy]

  def index
    # .tasksはmodelのアソシエーションメソッド
    @task = current_user.tasks
    @tasks = @task.page(params[:page]).per(5)

    if params[:sort_created]
      @tasks = @tasks.created_sort
    elsif  params[:sort_expired]
      @tasks = @tasks.deadline_sort
    elsif  params[:sort_priority]
      @tasks = @tasks.priority_sort
    end

    if params[:status].present? && params[:search].present?
      @tasks = Task.status_search(params[:status]).title_search(params[:search])
      @tasks = @tasks.page(params[:page])
    elsif params[:status].present?
      @tasks = Task.status_search(params[:status])
      @tasks = @tasks.page(params[:page])
    elsif params[:search].present?
      @tasks = Task.title_search(params[:search])
      @tasks = @tasks.page(params[:page])
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to tasks_path, notice: "作成しました！"
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice:"更新しました！"
    else
      render :edit
    end
  end

  def destroy
    redirect_to tasks_path, notice:"削除しました"
    @task.destroy
  end

  private
  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
