module Support
  module ControllerHelper
    def stubs_current_user
      @user ||= FactoryGirl.build_stubbed(:user, nickname: "flyerhzm")
      controller.stubs(:current_user).returns(@user)
      controller.stubs(:authenticate_user!).returns(true)
    end

    def expects_user_and_repository
      @user ||= FactoryGirl.build_stubbed(:user)
      @repository ||= FactoryGirl.build_stubbed(:repository)

      users = []
      User.expects(:where).with(nickname: "flyerhzm").returns(users)
      users.expects(:first).returns(@user)

      repositories = []
      @user.expects(:repositories).returns(repositories)
      repositories.expects(:where).with(name: "rails-brakeman.com").returns(repositories)
      repositories.expects(:first).returns(@repository)
    end

    def add_ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @controller.stubs(:current_ability).returns(@ability)
    end
  end
end
