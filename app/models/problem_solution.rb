# == Schema Information
#
# Table name: problem_solutions
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  problem_id  :bigint           not null
#  solution_id :bigint           not null
#
# Indexes
#
#  index_problem_solutions_on_problem_id                  (problem_id)
#  index_problem_solutions_on_problem_id_and_solution_id  (problem_id,solution_id) UNIQUE
#  index_problem_solutions_on_solution_id                 (solution_id)
#
class ProblemSolution < ApplicationRecord
  belongs_to :problem
  belongs_to :solution
end
