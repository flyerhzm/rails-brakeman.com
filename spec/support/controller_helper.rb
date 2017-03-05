module Support
  module ControllerHelper
    def stubs_current_user
      @user = create :user, nickname: 'flyerhzm'
      allow(controller).to receive(:current_user).and_return(@user)
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    def add_ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      allow(@controller).to receive(:current_ability).and_return(@ability)
    end
  end
end
