class AddAverageToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :average_rating, :float
    add_column :books, :reviews_count, :integer
  end
end
