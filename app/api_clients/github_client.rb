class GithubClient < ApplicationClient
  BASE_URI = "https://api.github.com"

  def current_user
    get "/user", query: { access_token: token }
  end

  def default_headers
    {
      "Accept" => "application/vnd.github+json"
    }
  end
end
