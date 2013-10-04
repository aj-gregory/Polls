class Question < ActiveRecord::Base
  attr_accessible :poll_id, :body

  validates :body, :presence => true
  validates :poll_id, :presence => true

  belongs_to :poll,
    :class_name => "Poll",
    :foreign_key => :poll_id,
    :primary_key => :id

  has_many :answer_choices,
    :class_name => "AnswerChoice",
    :foreign_key => :question_id,
    :primary_key => :id

  def results
    answers = self.answer_choices
      .select("answer_choices.*, COUNT(*) AS responses_count")
      .joins("JOIN responses ON answer_choices.id = responses.answer_choice_id")
      .group("answer_choices.id")

    answer_counts = {}

    self.answer_choices.each do |answer|
      answer_counts[answer.answer_body] = 0
    end

    answers.each do |answer|
      answer_counts[answer.answer_body] = answer.responses_count
    end

    answer_counts
  end
end
