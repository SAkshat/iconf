class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # To Do: Why are we using trackable?
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, foreign_key: :creator_id, dependent: :destroy
  has_many :discussions_users, dependent: :destroy
  has_many :discussions, through: :discussions_users, dependent: :destroy

end
