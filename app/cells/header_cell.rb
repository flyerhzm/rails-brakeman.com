class HeaderCell < Cell::Rails

  def display(user)
    @user = user
    render
  end

end
