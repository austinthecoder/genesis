class AddSlugIndexToPages < ActiveRecord::Migration
  def self.up
    add_index :pages, [:ancestry, :slug], :unique => true
  end

  def self.down
    remove_index :pages, [:ancestry, :slug]
  end
end
