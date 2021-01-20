class TasksController < ApplicationController
  before_action :basic_auth, if: :production?
  before_action :set_task, only: [:edit, :show, :update, :destroy]

  def index
    @tasks = Task.all
    @tasks = @tasks.created_sort
    if  params[:sort_expired]
      @tasks = Task.all.deadline_sort
    end
    if params[:task].present?
      @tasks = @tasks.search_status_sort(params[:task])
    elsif params[:status].present?
      @tasks = @tasks.status_sort(params[:status])
    elsif params[:search].present?
      @tasks = @tasks.title_sort(params[:search])
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
    params.require(:task).permit(:title, :content, :deadline, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
