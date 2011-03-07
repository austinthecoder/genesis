class Page < ActiveRecord::Base

  has_ancestry

  ### associations ###
  belongs_to :user

  ### normalizations ###
  normalize_attributes :slug

  ### validations ###
  validates :slug, :inclusion => {:in => [nil], :if => :is_root?}
  validates :user_id, :presence => true

  def slug_editable?
    !is_root?
  end

end