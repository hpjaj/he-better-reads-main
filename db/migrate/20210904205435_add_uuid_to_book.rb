class AddUuidToBook < ActiveRecord::Migration[6.1]
  def up
    add_column :books, :uuid, :string, unique: true

    Book.find_each do |book|
      book.initialize_uuid
      book.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "AddUuidToBook Migration experienced: Book - #{book.id}, error - #{e.record.errors.full_messages}"
    end

    change_column_null :books, :uuid, false
    add_index :books, :uuid, unique: true
  end

  def down
    remove_index :books, :uuid
    remove_column :books, :uuid
  end
end
