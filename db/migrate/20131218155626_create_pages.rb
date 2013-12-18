class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :wiki, index: true
      t.string :name
      t.text :content

      t.timestamps
    end
    add_index :pages, [:wiki_id, :name], :unique => true
  end
end
