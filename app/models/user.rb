class User < ActiveRecord::Base
  has_many :scores
  validates :name, :nickname, :presence => true
end
