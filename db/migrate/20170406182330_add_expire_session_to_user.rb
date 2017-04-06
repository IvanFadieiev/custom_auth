class AddExpireSessionToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :expire_session, :timestamp
  end
end
