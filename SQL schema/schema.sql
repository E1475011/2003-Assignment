SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS assessment;
DROP TABLE IF EXISTS login_session;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS submission;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE students (
    username VARCHAR(100) PRIMARY KEY,
    password_hash VARCHAR(32)
);

CREATE TABLE login_session (
    session_id VARCHAR(100) PRIMARY KEY,
    username VARCHAR(100),
    started_at DATETIME,
    FOREIGN KEY (username) REFERENCES students(username)
);

CREATE TABLE assessment (
    aid INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    due_date DATETIME
);

CREATE TABLE task (
    tid INT PRIMARY KEY AUTO_INCREMENT,
    aid INT,
    title VARCHAR(200),
    FOREIGN KEY (aid) REFERENCES assessment(aid)
);

CREATE TABLE submission (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    tid INT,
    username VARCHAR(100),
    code VARCHAR(1000),
    attempt_no INT,
    score FLOAT(3),
    submitted_at DATETIME,
    FOREIGN KEY (tid) REFERENCES task(tid),
    FOREIGN KEY (username) REFERENCES login_session(username)
);

INSERT INTO students (username, password_hash)
    VALUES -- default password is username + 1, example: username 'ben', password 'ben1'
    ('ben', '6edfe0531855295c5541d2666d604463'),
    ('benn', 'ea2b11c7e6bc373c628be113847b039d'),
    ('sasi', 'aa6bfe8bcf6eb51f7e158d8e5101fb71'),
    ('tricia', '0b4d4ee0c8e3cda51616f1f6cc64a655'),
    ('zongyu', '6e4a828704323be31656ec168be89920'),
    ('jiang', 'aa6bfe8bcf6eb51f7e158d8e5101fb71');

INSERT INTO assessment (title, due_date) VALUES
('Math Quiz 1', '2025-07-01 09:00:00'),
('Science Project Submission', '2025-07-05 23:59:00'),
('History Essay', '2025-07-10 17:00:00'),
('Computer Science Midterm', '2025-07-15 10:30:00'),
('English Literature Presentation', '2025-07-20 14:00:00'),
('Biology Lab Report', '2025-07-25 12:00:00'),
('Geography Fieldwork', '2025-07-30 08:00:00'),
('Economics Assignment', '2025-08-01 16:00:00');
