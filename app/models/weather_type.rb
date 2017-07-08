class WeatherType < ApplicationRecord
  has_many :runs
  validates :name, presence: true
end
