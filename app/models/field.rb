class Field < ActiveRecord::Base

  TYPE_OPTIONS = {
    'short_text' => 'short text',
    'long_text' => 'long text'
  }

  has_paper_trail

  ### associations ###
  belongs_to :template
  has_many :pages, :through => :template
  has_many :contents

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :template_id, :presence => true
  validates :name,
    :presence => true,
    :uniqueness => {:scope => :template_id}
  validate :on => :create do
    if TYPE_OPTIONS.keys.exclude?(field_type)
      errors.add(:field_type, "must be one of #{TYPE_OPTIONS.keys.inspect}")
    end
  end
  validate :on => :update do
    errors.add(:field_type, "cannot be changed") if field_type_changed?
  end

  ### callbacks ###
  after_create do
    pages.each do |p|
      unless contents.find_by_page_id(p.id)
        contents.create!(:page => p)
      end
    end
  end

  def human_field_type
    TYPE_OPTIONS[self[:field_type]]
  end

end