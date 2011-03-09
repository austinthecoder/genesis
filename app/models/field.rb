class Field < ActiveRecord::Base

  TYPE_OPTIONS = {
    'short_text' => 'short text',
    'long_text' => 'long text'
  }

  has_paper_trail

  ### associations ###
  belongs_to :template
  has_many :pages, :through => :template
  has_many :contents, :dependent => :destroy

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :template_id, :presence => true
  validates :field_type, :inclusion => {:in => TYPE_OPTIONS.keys}
  validates :name,
    :presence => true,
    :uniqueness => {:scope => :template_id}

  ### callbacks ###
  after_create do
    pages.each { |p| contents.create!(:page => p) }
  end

  def human_field_type
    TYPE_OPTIONS[self[:field_type]]
  end

end