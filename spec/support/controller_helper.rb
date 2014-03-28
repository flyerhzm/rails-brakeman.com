module Support
  module ControllerHelper
    def stubs_current_user
      @user ||= build_stubbed(:user, nickname: "flyerhzm")
      controller.stubs(:current_user).returns(@user)
      controller.stubs(:authenticate_user!).returns(true)
    end

    def add_ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @controller.stubs(:current_ability).returns(@ability)
    end
  end
end
