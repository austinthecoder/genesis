class Field < ActiveRecord::Base

  TYPE_OPTIONS = {
    'short_text' => 'short text',
    'long_text' => 'long text'
  }

  has_paper_trail

  ### associations ###
  belongs_to :template

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :template_id, :presence => true
  validates :field_type, :inclusion => {:in => TYPE_OPTIONS.keys}
  validates :name,
    :presence => true,
    :uniqueness => {:scope => :template_id}

  def human_field_type
    TYPE_OPTIONS[self[:field_type]]
  end

  ### callbacks ###
  after_create do
    if template
      template.pages.each do |p|
        Content.create!(:page => p, :field => self)
      end
    end
  end

end