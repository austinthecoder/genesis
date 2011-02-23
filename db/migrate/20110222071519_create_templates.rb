class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.text :content

      t.timestamps
    end

    add_index :templates, :name, :unique => true
  end

  def self.down
    drop_table :templates
  end
end
