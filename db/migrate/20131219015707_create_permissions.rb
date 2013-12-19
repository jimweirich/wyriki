class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user, index: true
      t.references :wiki, index: true
      t.string :role

      t.timestamps
    end
  end
end
