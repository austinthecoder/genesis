class Field < ActiveRecord::Base

  TYPE_OPTIONS = {
    'short_text' => 'short text',
    'long_text' => 'long text'
  }

  has_paper_trail

  ### associations ###
  belongs_to :template

  ### validations ###
  validates :name, :presence => true

  def human_field_type
    TYPE_OPTIONS[self[:field_type]]
  end

end