class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :show, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: :desc)
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
  def task_params
    params.require(:task).permit(:title, :content)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
