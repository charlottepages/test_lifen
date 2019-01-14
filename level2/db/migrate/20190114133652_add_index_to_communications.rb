class AddIndexToCommunications < ActiveRecord::Migration[5.2]
  def change
    add_index :communications, :practitioner_id
  end
end
