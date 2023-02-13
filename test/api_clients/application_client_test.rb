require "test_helper"

class ApplicationClientTest < ActiveSupport::TestCase
  setup do
    @client = ApplicationClient.new(token: "test")
  end

  test "token" do
    assert_equal "test", @client.token
  end

  test "authorization header" do
    stub_request(:get, "https://example.org/").with(headers: {"Authorization" => "Bearer test"})
    @client.send(:get, "/")
  end

  test "get" do
    stub_request(:get, "https://example.org/todos").to_return(body: "[]")
    assert_equal [], @client.send(:get, "/todos")
  end

  test "get with query params" do
    stub_request(:get, "https://example.org/").with(query: {"foo" => "bar"})
    @client.send(:get, "/", query: {foo: :bar})
  end

  test "post" do
    stub_request(:post, "https://example.org/todos").with(body: {"foo" => {"bar" => "baz"}})
    @client.send(:post, "/todos", body: {foo: {bar: :baz}})
  end

  test "put" do
    stub_request(:put, "https://example.org/todos/1").with(body: {"foo" => {"bar" => "baz"}})
    @client.send(:put, "/todos/1", body: {foo: {bar: :baz}})
  end

  test "patch" do
    stub_request(:patch, "https://example.org/todos/1").with(body: {"foo" => {"bar" => "baz"}})
    @client.send(:patch, "/todos/1", body: {foo: {bar: :baz}})
  end

  test "delete" do
    stub_request(:delete, "https://example.org/todos/1")
    @client.send(:delete, "/todos/1")
  end

  test "500" do
    stub_request(:get, "https://example.org/").to_return(status: 500)
    assert_raises ApplicationClient::Error do
      @client.send(:get, "/")
    end
  end
end
