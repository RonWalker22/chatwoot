class CreateClarificationThreads < ActiveRecord::Migration[6.0]
  def change
    create_table :clarification_threads do |t|
      t.references :feedback, null: false, foreign_key: true
      t.references :proposal, null: true, foreign_key: true

      t.timestamps
    end
  end
end
