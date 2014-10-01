class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :name
      t.text :content
      t.integer :rating
      t.references :product, index: true

      t.timestamps
    end
  end
end
