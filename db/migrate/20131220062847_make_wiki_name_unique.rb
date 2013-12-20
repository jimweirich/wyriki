class MakeWikiNameUnique < ActiveRecord::Migration
  def change
    add_index "wikis", ["name"], name: "index_wikis_on_name", unique: true
  end
end
