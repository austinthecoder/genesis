class Page < ActiveRecord::Base

  has_ancestry :orphan_strategy => :restrict
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
  has_many :fields, :through => :template do
    def create_contents!
      each { |f| f.contents.create!(:page => proxy_owner) }
    end
  end

  accepts_nested_attributes_for :contents

  ### normalizations ###
  normalize_attributes :slug, :title

  ### validations ###
  validates :slug,
    :unless => :is_root?,
    :presence => true,
    :format => {:with => /^[a-z0-9\-_]+$/i},
    :uniqueness => {:scope => :ancestry}
  validate(:if => :is_root?) do
    errors.add(:slug, 'must be nil') if slug
  end
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :template_id, :presence => true

  class << self
    # example: /contact/our-company
    def find_by_request_path(path)
      Page.all.detect do |p|
        ("/" + p.path.map(&:slug).tap(&:shift).join("/")) == path
      end
    end
  end

  delegate :name, :to => :template, :prefix => true, :allow_nil => true

  def to_html
    liquid_template.render('page' => Drop.new(self))
  end

  def slug_editable?
    !is_root?
  end

  def can_destroy?
    new_record? || is_childless?
  end

  private

  def liquid_template
    @liquid_template ||= Liquid::Template.parse(template.content)
  end

end