class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def self.find_for_github_oauth(data)
    if user = User.find_by_github_uid(data.uid)
      user
    else # Create a user with a stub password.
      user = User.new(:email => data.info.email, :password => Devise.friendly_token[0, 20])
      user.github_uid = data.uid
      user.name = data.info.name
      user.nickname = data.info.nickname
      user.save
      user
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["user_info"]
        user.email = data["email"]
      end
    end
  end
end
