class LegacyColor < ActiveRecord::Base
  self.primary_key = :uid
  
  enumerate_by :name
end
