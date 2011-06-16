class Template < ActiveRecord::Base

  has_paper_trail

  ### associations ###
  belongs_to :user
  has_many :fields do
    # TODO: test
    def add!(*args)
      create!(*args).tap do |field|
        field.pages.each do |page|
          unless field.contents.find_by_page_id(page.id)
            field.contents.create!(:page => page)
          end
        end
      end
    end
  end
  has_many :pages

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true

end