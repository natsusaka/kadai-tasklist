class TasksController < ApplicationController
  #事前のログイン確認
    before_action :require_user_logged_in
  #本当にログインユーザが所有しているものかを確認
    before_action :correct_user, only: [:show, :edit, :update, :destroy]
    
    def index
      if logged_in?
          @tasks = current_user.tasks.build
          @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(10)
      end
    end

    def show
    end

    def new
        @task = Task.new
    end

    def create
      @task = current_user.tasks.build(task_params)
        if @task.save
            flash[:success] = 'タスクが正常に登録されました'
            redirect_to root_url
        else
          @tasks = current_user.tasks.order(id: :desc).page(params[:page])
            flash.now[:danger] = 'タスクが登録されませんでした'
            render :new
        end
    end

    def edit
    end

    def update
        
        if @task.update(task_params)
            flash[:success] = 'タスクは正常に更新されました'
            redirect_to @task
        else
            flash.now[:danger] = 'タスクは更新されませんでした'
            render :edit
        end
    end

    def destroy
        @task.destroy
        
        flash[:success] = 'タスクは正常に削除されました'
        redirect_to tasks_url
    end

    private
    
    #Strong Parameter
    
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    #本当にログインユーザが所有しているものかを確認
    #1つのタスクを取得する流れのため、@tasksよりも@taskのほうが適切な変数名（どんな名称でも利用はできるが）
    #パラメーターparams[:id]を取得し、@taskに入れる⇨before_actionで実行しているので、show、edit,update,destroyで再度定義する必要はない
    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      unless @task
        redirect_to root_url
      end
    end
end

