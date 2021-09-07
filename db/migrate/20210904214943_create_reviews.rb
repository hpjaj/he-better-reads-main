class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reviewable, polymorphic: true
      t.text :description
      t.integer :rating, null: false

      t.timestamps
    end
  end
end
