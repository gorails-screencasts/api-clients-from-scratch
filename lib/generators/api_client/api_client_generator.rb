class ApiClientGenerator < Rails::Generators::NamedBase
  # rails generate api_client Todo
  # rails destroy api_client Todo

  source_root File.expand_path("templates", __dir__)

  def copy_templates
    template "client.rb", "app/api_clients/#{file_path}_client.rb"
    template "client_test.rb", "test/api_clients/#{file_path}_client_test.rb"
  end
end
