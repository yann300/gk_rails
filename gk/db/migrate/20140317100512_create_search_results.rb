class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.string :url
      t.string :content
      t.string :matched_content
      t.string :title

      t.timestamps
    end
  end
end
