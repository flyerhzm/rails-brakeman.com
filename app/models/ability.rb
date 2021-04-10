# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :access, :rails_admin
      can :manage, :all
    end

    can :read, Repository, visible: true
    can :read, Repository, id: user.repository_ids

    can [:new, :create], Repository
    can [:edit, :update], Repository, id: user.repository_ids

    can :read, Build, repository: { visible: true }
    can :read, Build, repository: { id: user.repository_ids }
  end
end
