class Page < ActiveRecord::Base

  has_ancestry

  ### associations ###
  belongs_to :user
  belongs_to :template
  has_many :contents, :dependent => :destroy
  has_many :fields, :through => :template

  accepts_nested_attributes_for :contents

  ### normalizations ###
  normalize_attributes :slug, :title

  ### validations ###
  validates :slug,
    :presence => {:unless => :is_root?},
    :inclusion => {:in => [nil], :if => :is_root?},
    :format => {:with => /^[a-z0-9\-_]+$/i, :unless => :is_root?}
  validates :user_id, :presence => true
  validates :title, :presence => true

  ### callbacks ###
  after_create do
    fields.each do |f|
      contents.create!(:field => f)
    end
  end

  def slug_editable?
    !is_root?
  end

end