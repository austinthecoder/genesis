class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.belongs_to :template
      t.string :name
      t.string :field_type
      t.timestamps
    end

    add_index :fields, :template_id
    add_index :fields, [:template_id, :name], :unique => true
  end

  def self.down
    drop_table :fields
  end
end
