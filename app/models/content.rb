class Content < ActiveRecord::Base

  ### assocications ###
  belongs_to :page
  belongs_to :field

end