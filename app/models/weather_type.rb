class WeatherType < ActiveRecord::Base
  has_many :runs
  validates :name, presence: true
end
