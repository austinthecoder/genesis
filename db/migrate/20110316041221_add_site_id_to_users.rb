class AddSiteIdToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) { |t| t.belongs_to :site }

    add_index :users, :site_id
  end

  def self.down
    remove_index :users, :site_id

    remove_column :users, :site_id
  end
end
