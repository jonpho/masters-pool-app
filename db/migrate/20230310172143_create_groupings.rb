class CreateGroupings < ActiveRecord::Migration[7.0]
  def change
    create_table :groupings do |t|
      t.string :flight

      t.timestamps
    end
  end
end
