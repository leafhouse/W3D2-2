require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions2.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_accessor :id, :title, :author_id, :body

  def self.find_by_id(id)
    q = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless q.length > 0
    Question.new(q.first)
  end

  def initialize(params)
    @id = params['id']
    @title = params['title']
    @author_id = params['author_id']
    @body = params['body']
  end

  def self.find_by_author_id(author_id)
    q = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL
    return nil unless q.first
    Question.new(q.first)
  end

  def author
    self.author_id
    a = QuestionsDatabase.instance.execute(<<-SQL, b=self.author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(a.first)
  end
end

class Reply 
  attr_accessor :id, :parent_reply, :question_id, :body, :user_id

  def self.find_by_user_id(user_id)
    u = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    Reply.new(u.first)   
  end

  def initialize(params)
    @id = params['id']
    @parent_reply = params['parent_reply']
    @question_id = params['question_id']
    @body = params['body']
    @user_id = params['user_id']
  end

  def self.find_by_question_id(question_id)
    r = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    allreplies = []
    r.each do |reply|
      allreplies << Reply.new(reply)
    end
    allreplies
  end
end

class User
  attr_accessor :id, :fname, :lname
  def initialize(params)
    @id = params['id']
    @fname = params['fname']
    @lname = params['lname']
  end

  def self.find_by_name(fname, lname)
    u = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
        AND lname = ?
    SQL
    User.new(u.first)
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end
end


