class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  counter_culture :recipe

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, length: { maximum: 500 }, presence: true
end
