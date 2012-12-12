class ServiceProspect < ActiveRecord::Base
  belongs_to :service
  belongs_to :prospect
end
