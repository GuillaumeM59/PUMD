class Carbrand < ActiveRecord::Base
  has_many :carmodels, dependent: :destroy





end
