class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.belongs_to :page
      t.belongs_to :field
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
