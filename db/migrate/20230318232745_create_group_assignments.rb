class CreateGroupAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :group_assignments do |t|
      t.belongs_to :grouping
      t.belongs_to :golfer

      t.timestamps
    end
  end
end
