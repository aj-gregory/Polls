class User < ActiveRecord::Base
  attr_accessible :user_name

  validates :user_name, :uniqueness => true, :presence => true

  has_many :authored_polls,
    :class_name => "Poll",
    :foreign_key => :user_id,
    :primary_key => :id

  has_many :responses,
    :class_name => "Response",
    :foreign_key => :user_id,
    :primary_key => :id


  def poll_question_count

  end

  def completed_polls
    polls = Poll.find_by_sql [<<-SQL, self.id]
      SELECT polls.title, COUNT(DISTINCT questions.id) AS num_questions,
       (SELECT COUNT(responses.id)
        FROM polls
        JOIN questions
        ON polls.id = questions.poll_id
        JOIN answer_choices
        ON questions.id = answer_choices.question_id
        JOIN responses
        ON responses.answer_choice_id = answer_choices.id
        WHERE responses.user_id = ?
        GROUP BY questions.poll_id) AS num_responses
      FROM polls
      JOIN questions
      ON polls.id = questions.poll_id
      JOIN answer_choices
      ON questions.id = answer_choices.question_id
      JOIN responses
      ON responses.answer_choice_id = answer_choices.id
      GROUP BY questions.poll_id
      HAVING num_questions - num_responses = 0
    SQL

    polls.map { |poll| poll.title }
  end

  def incomplete_polls
    polls = Poll.find_by_sql [<<-SQL, self.id]
      SELECT polls.title, COUNT(DISTINCT questions.id) AS num_questions,
       (SELECT COUNT(responses.id)
        FROM polls
        JOIN questions
        ON polls.id = questions.poll_id
        JOIN answer_choices
        ON questions.id = answer_choices.question_id
        JOIN responses
        ON responses.answer_choice_id = answer_choices.id
        WHERE responses.user_id = ?
        GROUP BY questions.poll_id) AS num_responses
      FROM polls
      JOIN questions
      ON polls.id = questions.poll_id
      JOIN answer_choices
      ON questions.id = answer_choices.question_id
      JOIN responses
      ON responses.answer_choice_id = answer_choices.id
      GROUP BY questions.poll_id
      HAVING num_questions - num_responses > 0
    SQL

    polls.map { |poll| poll.title }
  end
end
