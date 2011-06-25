class Template < ActiveRecord::Base

  has_paper_trail

  ### associations ###
  belongs_to :user
  has_many :fields do
    def add!(*args)
      create!(*args).tap do |f|
        f.pages.each { |p| p.contents.create!(:field => f) }
      end
    end
  end
  has_many :pages

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true

  def destroy_with_page_checking
    destroy_without_page_checking if pages.empty?
  end

  alias_method_chain :destroy, :page_checking

  def destroy!
    destroy || raise
  end

end