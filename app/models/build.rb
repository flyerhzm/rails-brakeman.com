class Build < ActiveRecord::Base
  include AASM

  belongs_to :repository, :counter_cache => 1
  attr_accessible :branch, :duration, :finished_at, :last_commit_id, :last_commit_message, :position

  before_create :set_position
  after_destroy :remove_analyze_file

  scope :completed, where(:aasm_state => "completed")

  aasm do
    state :scheduled, initial: true
    state :running, enter: :analyze
    state :completed
    state :failed

    event :run do
      transitions to: :running, from: :scheduled
    end

    event :complete do
      transitions to: :completed, from: [:running, :scheduled]
    end

    event :fail do
      transitions to: :failed, from: :running
    end

    event :rerun do
      transitions to: :running, from: [:failed, :completed]
    end
  end

  def analyze_file
    analyze_path + "/brakeman.html"
  end

  def analyze
    start_time = Time.now
    FileUtils.mkdir_p(analyze_path) unless File.exist?(analyze_path)
    FileUtils.cd(analyze_path)
    g = Git.clone(repository.clone_url, repository.name)
    Dir.chdir(repository.name) { g.reset_hard(last_commit_id) }
    Brakeman.run({
      :app_path => "#{analyze_path}/#{repository.name}",
      :output_formats => :html,
      :output_files => [analyze_file]
    })
    end_time = Time.now
    self.duration = end_time - start_time
    self.finished_at = end_time
    complete!
    self.repository.touch(:last_build_at)
    remove_brakeman_header
  ensure
    FileUtils.rm_rf("#{analyze_path}/#{repository.name}")
  end
  handle_asynchronously :analyze

  protected
    def set_position
      self.position = repository.builds_count + 1
    end

    def remove_analyze_file
      FileUtils.rm(analyze_file) if File.exist?(analyze_file)
    end

    def analyze_path
      Rails.root.join("builds", repository.github_name, "commit", last_commit_id).to_s
    end

    def remove_brakeman_header
      content = File.read(analyze_file)
      content.sub!(/<h1>.*?<\/h1>\n<table>.*?<\/table>/m, "")
      File.write(analyze_file, content)
    end
end
