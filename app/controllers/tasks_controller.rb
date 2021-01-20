class TasksController < ApplicationController
  before_action :basic_auth, if: :production?
  before_action :set_task, only: [:edit, :show, :update, :destroy]

  def index

    if params[:sort_created]
      @tasks = Task.all.created_sort
    else  params[:sort_expired]
      @tasks = Task.all.deadline_sort
    end

    if params[:status].present? && params[:search].present?
      @tasks = Task.status_search(params[:status]).title_search(params[:search])
    elsif params[:status].present?
      @tasks = Task.status_search(params[:status])
    elsif params[:search].present?
      @tasks = Task.title_search(params[:search])
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
