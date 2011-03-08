class Page < ActiveRecord::Base

  has_ancestry

  ### associations ###
  belongs_to :user

  ### normalizations ###
  normalize_attributes :slug, :title

  ### validations ###
  validates :slug,
    :presence => {:unless => :is_root?},
    :inclusion => {:in => [nil], :if => :is_root?},
    :format => {:with => /^[a-z0-9\-_]+$/i, :unless => :is_root?}
  validates :user_id, :presence => true
  validates :title, :presence => true

  def slug_editable?
    !is_root?
  end

end