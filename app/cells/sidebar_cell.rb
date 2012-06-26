class SidebarCell < Cell::Rails

  def display
    @latest_repositories = Repository.latest.limit(10)
    render
  end

end
