DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


PRAGMA foreign_keys = ON;



CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  parent_reply INTEGER,
  question_id INTEGER NOT NULL,
  body VARCHAR(255),
  user_id INTEGER NOT NULL,

  FOREIGN KEY (parent_reply) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Brian', 'Wilson');

INSERT INTO
  users (fname, lname)
VALUES
  ('Donald', 'Trump');


INSERT INTO
  questions (id, title, body, author_id)
VALUES
  (1, 'What''s up', 'How is everyone', (SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Wilson'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Wilson'), (SELECT id FROM questions WHERE title = 'What''s up' AND body = 'How is everyone'));

INSERT INTO
  replies (parent_reply, question_id, body, user_id)
VALUES
  (NULL, (SELECT id FROM questions WHERE title = 'What''s up' AND body = 'How is everyone'), "I'm pretty good", (SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Wilson'));

INSERT INTO
  replies (parent_reply, question_id, body, user_id)
VALUES
  ((SELECT id FROM replies WHERE body = "I''m pretty good"), (SELECT id FROM questions WHERE title = 'What''s up' AND body = 'How is everyone'), "Thank you Brian, very cool!", (SELECT id FROM users WHERE fname = 'Donald' AND lname = 'Trump'));


INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'What''s up' AND body = 'How is everyone'), (SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Wilson')); 
