class CreateProblemSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_solutions do |t|
      t.references :problem, null: false
      t.references :solution, null: false
      t.timestamps
    end
    add_index :problem_solutions, [:problem_id, :solution_id], unique: true
  end
end
