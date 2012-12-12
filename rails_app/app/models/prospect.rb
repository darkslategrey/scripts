class Prospect < ActiveRecord::Base
  attr_accessible :addr, :contact, :departement, :fax, :mail, :name, :srvc_code, :srvc_name, :tel, :url
  has_many :services_prospects
  has_many :services, :throught => :services_prospects

end
