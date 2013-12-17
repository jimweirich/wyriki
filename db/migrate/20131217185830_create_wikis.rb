class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :name
      t.string :home_page

      t.timestamps
    end
  end
end
