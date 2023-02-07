class TodosClient < ApplicationClient
  # client = TodosClient.new(token: "api_key2")
  # client.todos
  # client.todo(1)
  # client.create_todo(description: "test")

  BASE_URI = "http://localhost:3000"

  def todos(**kwargs)
    get "/todos", query: kwargs
  end

  def todo(id)
    get "/todos/#{id}"
  end

  def create_todo(description:)
    post "/todos", body: { todo: {description: description} }
  end

  def update_todo(id, description:)
    patch "/todos/#{id}", body: { todo: {description: description} }
  end

  def delete_todo(id)
    delete "/todos/#{id}"
  end
end
