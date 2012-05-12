class Repository < ActiveRecord::Base
  attr_accessible :description, :fork, :github_id, :github_name, :git_url, :name, :private, :pushed_at
  before_create :sync_github

  protected
    def sync_github
      client = Octokit::Client.new(oauth_token: User.current.github_token)
      repo = client.repository(github_name)
      self.github_id = repo.id
      self.name = repo.name
      self.description = repo.description
      self.git_url = repo.git_url
      self.private = repo.private
      self.fork = repo.fork
      self.pushed_at = repo.pushed_at
      true
    end
end
