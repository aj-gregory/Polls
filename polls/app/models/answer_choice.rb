class AnswerChoice < ActiveRecord::Base
  attr_accessible :question_id, :answer_body

  validates :answer_body, :presence => true
  validates :question_id, :presence => true

  belongs_to :question,
    :class_name => "Question",
    :foreign_key => :question_id,
    :primary_key => :id

  has_many :responses,
    :class_name => "Response",
    :foreign_key => :answer_choice_id,
    :primary_key => :id
end
