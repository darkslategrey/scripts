class Service < ActiveRecord::Base
  attr_accessible :code, :libelle

  has_many :services_prospects
  has_many :prospects, :through => :services_prospects
end
