class Response < ActiveRecord::Base
  attr_accessible :user_id, :answer_choice_id

  validates :user_id, :presence => true
  validates :answer_choice_id, :presence => true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_the_poll_creator

  belongs_to :answer_choice,
    :class_name => "AnswerChoice",
    :foreign_key => :answer_choice_id,
    :primary_key => :id

  belongs_to :respondent,
    :class_name => "User",
    :foreign_key => :user_id,
    :primary_key => :id

  def respondent_has_not_already_answered_question
    if existing_responses.count != 0 && existing_responses.first.id != self.id
      errors[:user_id] << "already answered this question"
    end
  end

  def respondent_is_not_the_poll_creator
    poll_creator = User
      .joins(:authored_polls => {:questions => :answer_choices})
      .where('answer_choices.id = ?', self.answer_choice_id)
      .first
    if poll_creator.id == self.user_id
      errors[:user_id] << "cannot respond to own poll"
    end
  end

  private

  def existing_responses
    Response.find_by_sql [<<-SQL, self.user_id, self.answer_choice_id]
    SELECT
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
        id = ? )
    SQL
  end
end
