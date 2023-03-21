class CreateGolfers < ActiveRecord::Migration[7.0]
  def change
    create_table :golfers, id: false do |t|
      t.bigint :player_id, primary_key: true
      t.string :name
      t.string :tour
      t.string :status

      t.timestamps
    end

    create_table :leaderboards do |t|
      t.belongs_to :golfer
      t.integer :year
      t.integer :position
      t.integer :round_one
      t.integer :round_two
      t.integer :round_three
      t.integer :round_four
      t.integer :total
      t.integer :earnings

      t.timestamps
    end
  end
end
