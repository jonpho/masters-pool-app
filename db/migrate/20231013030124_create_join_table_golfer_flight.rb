class CreateJoinTableGolferFlight < ActiveRecord::Migration[7.0]
  def change
    create_join_table :golfers, :flights do |t|
      t.index [:golfer_id, :flight_id]
      t.index [:flight_id, :golfer_id]
    end
  end
end
