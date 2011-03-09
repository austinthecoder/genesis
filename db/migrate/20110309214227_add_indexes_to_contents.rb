class AddIndexesToContents < ActiveRecord::Migration
  def self.up
    add_index :contents, :field_id
    add_index :contents, :page_id
    add_index :contents, [:page_id, :field_id], :unique => true
  end

  def self.down
    remove_index :contents, :field_id
    remove_index :contents, :page_id
    remove_index :contents, [:page_id, :field_id]
  end
end
