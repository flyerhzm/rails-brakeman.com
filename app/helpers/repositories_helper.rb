module RepositoriesHelper
  def latest_repositores
    Repository.latest.limit(10)
  end
end
