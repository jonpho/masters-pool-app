class CreateUserSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_submissions do |t|
      t.belongs_to :user
      t.belongs_to :golfer

      t.timestamps
    end
  end
end
