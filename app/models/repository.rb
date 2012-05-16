class Repository < ActiveRecord::Base
  has_many :builds, :dependent => :destroy
  belongs_to :user
  attr_accessible :description, :fork, :github_id, :github_name, :git_url, :name, :private, :pushed_at
  before_create :sync_github, :touch_last_build_at

  validates_uniqueness_of :github_id

  scope :latest, where("builds_count > 0").order("last_build_at desc")

  def clone_url
    private? ? ssh_url : git_url
  end

  def generate_build(branch, commit)
    build = self.builds.build(branch: branch, last_commit_id: commit["id"], last_commit_message: commit["message"])
    if build.save
      build.run!
    end
  end

  def to_param
    "#{id}-#{github_name.parameterize}"
  end

  protected
    def sync_github
      client = Octokit::Client.new(oauth_token: User.current.github_token)
      repo = client.repository(github_name)
      self.github_id = repo.id
      self.name = repo.name
      self.description = repo.description
      self.git_url = repo.git_url
      self.html_url = repo.html_url
      self.ssh_url = repo.ssh_url
      self.private = repo.private
      self.fork = repo.fork
      self.pushed_at = repo.pushed_at
      true
    end

    def touch_last_build_at
      last_build_at = Time.now
    end
end
