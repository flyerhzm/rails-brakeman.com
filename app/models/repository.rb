# == Schema Information
#
# Table name: repositories
#
#  id                   :integer(4)      not null, primary key
#  github_id            :integer(4)
#  github_name          :string(255)
#  name                 :string(255)
#  description          :string(255)
#  git_url              :string(255)
#  private              :boolean(1)
#  fork                 :boolean(1)
#  pushed_at            :datetime
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  last_build_at        :datetime
#  html_url             :string(255)
#  ssh_url              :string(255)
#  builds_count         :integer(4)      default(0)
#  user_id              :integer(4)
#  authentication_token :string(255)
#  visible              :boolean(1)      default(TRUE)
#  rails                :boolean(1)      default(FALSE), not null
#

class Repository < ActiveRecord::Base
  has_many :builds, dependent: :destroy
  belongs_to :user
  attr_accessible :description, :fork, :github_id, :github_name, :git_url, :html_url, :ssh_url, :name, :private, :visible, :pushed_at
  before_create :reset_authentication_token, :sync_github, :touch_last_build_at
  after_create :setup_github_hook

  validates_uniqueness_of :github_name

  scope :latest, where("visible = true and builds_count > 0").order("last_build_at desc")

  delegate :email, to: :user, prefix: true

  def clone_url
    private? ? ssh_url : git_url
  end

  def generate_build(branch, commit)
    return unless commit

    build = self.builds.build(branch: branch, last_commit_id: commit["id"], last_commit_message: commit["message"])
    if build.save
      build.run!
    end
  end

  def notify_privacy
    UserMailer.notify_repository_privacy(self).deliver
  end

  def to_param
    "#{id}-#{github_name.parameterize}"
  end

  def owner_name
    github_name.split("/").first
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

    def reset_authentication_token
      self.authentication_token = Devise.friendly_token
    end

    def touch_last_build_at
      last_build_at = Time.now
    end

    def setup_github_hook
      client = Octokit::Client.new(oauth_token: User.current.github_token)
      client.create_hook(self.github_name, "railsbrakeman", {rails_brakeman_url: "http://rails-brakeman.com", token: self.authentication_token})
      true
    end
end
