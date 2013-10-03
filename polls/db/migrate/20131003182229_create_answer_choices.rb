class CreateAnswerChoices < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.text :answer_body
      t.integer :question_id
      t.timestamps
    end
  end
end
