class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :rememberable, :trackable

  ### associations ###
  has_many :templates
  has_many :fields, :through => :templates
  has_many :pages

  ### validations ###
  validates :email,
    :presence => true,
    :format => {:with  => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :allow_blank => true},
    :uniqueness => {:case_sensitive => false, :allow_blank => true}
  validates :password,
    :presence => {:on => :create},
    :confirmation => {:if => :password_required?},
    :length => {:within => 6..20, :if => :password_required?}

  private

  def password_required?
    new_record? || password
  end

end