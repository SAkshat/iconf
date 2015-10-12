class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, foreign_key: :creator_id, dependent: :destroy
  has_many :discussions_users, dependent: :destroy
  has_many :discussions, through: :discussions_users

  scope :enabled, -> { where(enabled: true) }

  validates :name, presence: true
  validates :title, presence: true

  #SPEC CONSTANTS
  TITLES_LIST = ['Mr', 'Mrs', 'Ms', 'Dr']

  def self.find_or_create_from_twitter_params(auth_params)
    user = User.create_with(name: auth_params[:info][:name], nickname: auth_params[:info][:nickname], image_path: auth_params[:info][:image], twitter_url: auth_params[:info][:urls][:Twitter]).find_or_initialize_by(uid: auth_params[:uid])
    user.save(validate: false)
    user
  end

end
