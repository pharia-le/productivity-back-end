class Habit < ApplicationRecord
  belongs_to :user
  has_many :logs, dependent: :destroy

  validates :name, presence: true
end
