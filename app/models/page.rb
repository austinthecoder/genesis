class Page < ActiveRecord::Base

  has_ancestry :orphan_strategy => :rootify
  has_paper_trail

  ### associations ###
  belongs_to :user
  belongs_to :template
  has_many :contents, :dependent => :destroy do
    # contents that have a field that have a template
    def active
      joins(:field => :template)
    end
  end
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
  after_save do
    if template_id_changed?
      contents.each(&:destroy)
      fields.each { |f| contents.create!(:field => f) }
    end
  end

  def slug_editable?
    !is_root?
  end

end