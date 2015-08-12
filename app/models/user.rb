class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, foreign_key: :creator_id, dependent: :destroy
  has_many :discussions_users, dependent: :destroy
  has_many :discussions, through: :discussions_users, dependent: :destroy

  scope :enabled, -> { where(enabled: true) }

  validates :name, presence: true
  validates :designation, presence: true

  TITLES_LIST = ['Mr', 'Mrs', 'Ms', 'Dr']

end
