class AddSlugToPages < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.string :slug
      t.belongs_to :template
    end
    add_index :pages, :template_id
  end

  def self.down
    remove_index :pages, :template_id
    change_table :pages do |t|
      t.remove :slug
      t.remove :template_id
    end
  end
end
