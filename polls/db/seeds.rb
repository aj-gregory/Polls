# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ActiveRecord::Base.transaction do
  User.create!([{:user_name => "Frank"}])
  User.create!([{:user_name => "Jill"}])
  User.create!([{:user_name => "AJ"}])
  User.create!([{:user_name => "Jeff"}])

  Poll.create!([{:title => "Favorite things", :user_id => 1}])

  Question.create!([{:body => "What is your favorite color?", :poll_id => 1}])
  Question.create!([{:body => "What is your favorite food?", :poll_id => 1}])

  AnswerChoice.create!([{:answer_body => "Red", :question_id => 1}])
  AnswerChoice.create!([{:answer_body => "Blue", :question_id => 1}])

  AnswerChoice.create!([{:answer_body => "Lasagna", :question_id => 2}])
  AnswerChoice.create!([{:answer_body => "Tofu", :question_id => 2}])

  Response.create!([{:user_id => 2, :answer_choice_id => 2}])
  Response.create!([{:user_id => 2, :answer_choice_id => 3}])
  Response.create!([{:user_id => 2, :answer_choice_id => 4}]) #should raise   error
end