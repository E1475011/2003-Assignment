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
    FOREIGN KEY (username) REFERENCES students(username)
);

INSERT INTO students (username, password_hash)
    VALUES -- default password is username + 1, example: username 'ben', password 'ben1'
    ('ben', '6edfe0531855295c5541d2666d604463'),
    ('benn', 'ea2b11c7e6bc373c628be113847b039d'),
    ('sasi', 'aa6bfe8bcf6eb51f7e158d8e5101fb71'),
    ('tricia', '0b4d4ee0c8e3cda51616f1f6cc64a655'),
    ('zongyu', '6e4a828704323be31656ec168be89920'),
    ('jiang', '7ab645365238e9d6691ba55947269b20');

INSERT INTO assessment (title, due_date) VALUES
('Math Quiz 1', '2025-07-01 09:00:00'),
('Science Project Submission', '2025-07-05 23:59:00'),
('History Essay', '2025-07-10 17:00:00'),
('Computer Science Midterm', '2025-07-15 10:30:00'),
('English Literature Presentation', '2025-07-20 14:00:00'),
('Biology Lab Report', '2025-07-25 12:00:00'),
('Geography Fieldwork', '2025-07-30 08:00:00'),
('Economics Assignment', '2025-08-01 16:00:00');

INSERT INTO task (aid, title) VALUES
(1, 'Review algebra concepts'),
(1, 'Practice quiz questions'),

(2, 'Research topic and gather materials'),
(2, 'Prepare project slides'),

(3, 'Outline essay structure'),
(3, 'Write first draft'),

(4, 'Revise lecture notes'),
(4, 'Complete sample midterm'),

(5, 'Select literary work'),
(5, 'Prepare presentation slides'),

(6, 'Conduct lab experiment'),
(6, 'Write lab report'),

(7, 'Visit field site'),
(7, 'Document observations'),

(8, 'Analyze economic data'),
(8, 'Write summary report');

INSERT INTO submission (tid, username, code, attempt_no, score, submitted_at) VALUES
(1, 'ben', 'print("Algebra done")', 1, 85.0, '2025-06-30 08:00:00'),
(2, 'zongyu', 'print("Quiz practice")', 1, 90.0, '2025-06-30 08:30:00'),
(3, 'tricia', 'print("Research complete")', 1, 88.0, '2025-07-04 22:00:00'),
(4, 'ben', 'print("Slides ready")', 1, 92.0, '2025-07-05 20:00:00'),
(5, 'zongyu', 'print("Essay outline")', 1, 80.0, '2025-07-09 15:00:00'),
(6, 'tricia', 'print("Draft written")', 1, 75.0, '2025-07-10 16:00:00'),
(7, 'ben', 'print("Notes revised")', 1, 95.0, '2025-07-14 09:00:00'),
(8, 'zongyu', 'print("Midterm prep")', 1, 89.0, '2025-07-14 10:00:00'),
(9, 'tricia', 'print("Literature selected")', 1, 87.0, '2025-07-19 13:00:00'),
(10, 'ben', 'print("Slides done")', 1, 93.0, '2025-07-19 13:30:00'),
(11, 'zongyu', 'print("Lab experiment")', 1, 78.0, '2025-07-24 11:00:00'),
(12, 'tricia', 'print("Lab report")', 1, 82.0, '2025-07-25 11:30:00'),
(13, 'ben', 'print("Field site visited")', 1, 88.0, '2025-07-29 07:00:00'),
(14, 'zongyu', 'print("Observations documented")', 1, 91.0, '2025-07-30 07:30:00'),
(15, 'tricia', 'print("Data analyzed")', 1, 84.0, '2025-07-31 15:00:00'),
(16, 'ben', 'print("Summary written")', 1, 86.0, '2025-08-01 15:30:00');


