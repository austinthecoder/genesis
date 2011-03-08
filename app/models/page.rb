class Page < ActiveRecord::Base

  has_ancestry

  ### associations ###
  belongs_to :user

  ### normalizations ###
  normalize_attributes :slug

  ### validations ###
  validates :slug,
    :presence => {:unless => :is_root?},
    :inclusion => {:in => [nil], :if => :is_root?}
  validates :user_id, :presence => true
  validates :title, :presence => true

  def slug_editable?
    !is_root?
  end

end