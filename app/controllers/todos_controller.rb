class TodosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_authorization
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render :show, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    if @todo.update(todo_params)
      render :show, status: :ok, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:description)
    end

    def require_authorization
      key = request.headers.fetch("Authorization").split(" ").last
      if key != "api_key2"
        render json: {message: "Invalid API key"}, status: :unauthorized
      end
    end
end
