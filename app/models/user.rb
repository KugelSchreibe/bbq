class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events

  before_validation :set_name, on: :create
  validates :name, presence: true, length: { maximum: 35 }, format: { with: /\A\w+\z/ }

  private

  def set_name
    self.name = "new_user#{rand(777)}" if self.name.blank?
  end
end
