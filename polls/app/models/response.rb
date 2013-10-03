class Response < ActiveRecord::Base
  attr_accessible :user_id, :answer_choice_id

  validates :user_id, :presence => true
  validates :answer_choice_id, :presence => true
  validate :respondent_has_not_already_answered_question

  belongs_to :answer_choice,
    :class_name => "AnswerChoice",
    :foreign_key => :answer_choice_id,
    :primary_key => :id

  belongs_to :respondent,
    :class_name => "User",
    :foreign_key => :user_id,
    :primary_key => :id

  def respondent_has_not_already_answered_question
    return if existing_responses.count == 0
    if existing_responses.first.id != self.id
      errors[:already_answered] << "already answered this question"
    end
  end

  private

  def existing_responses
    Response.find_by_sql [
    "SELECT
      responses.id
    FROM
      responses
    JOIN
      answer_choices
    ON
      responses.answer_choice_id = answer_choices.id
    WHERE
      responses.user_id = ?
    AND
      answer_choices.question_id IN
      (SELECT
        question_id
      FROM
        answer_choices
      WHERE
        id = ? )", self.user_id, self.answer_choice_id]
  end
end
