# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  github_uid             :integer(4)
#  nickname               :string(255)
#  name                   :string(255)
#  github_token           :string(255)
#  admin                  :boolean(1)      default(FALSE), not null
#

class User < ActiveRecord::Base
  include Gravtastic
  is_gravtastic

  has_many :repositories

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  validates_uniqueness_of :github_uid

  def self.find_for_github_oauth(data)
    user = User.find_by_github_uid(data.uid) || User.new
    import_github_data(user, data)
    user.save
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["user_info"]
        user.email = data["email"]
      end
    end
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def fakemail?
    email =~ /@fakemail.com/
  end

  protected
    def self.import_github_data(user, data)
      user.email = data.info.email || "#{data.info.nickname}@fakemail.com"
      user.password = Devise.friendly_token[0, 20]
      user.github_uid = data.uid
      user.github_token = data.credentials.token
      user.name = data.info.name
      user.nickname = data.info.nickname
    end
end
