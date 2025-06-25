CREATE TABLE students (
    username VARCHAR(100) PRIMARY KEY,
    password_hash VARCHAR(32)
);

CREATE TABLE session (
    session_id VARCHAR(100) PRIMARY KEY,
    username VARCHAR(100),
    started_at DATETIME,
    FOREIGN KEY (username) REFERENCES students(username)
);

CREATE TABLE assessment (
    aid VARCHAR(100) PRIMARY KEY,
    title VARCHAR(200),
    due_date DATETIME
);

CREATE TABLE task (
    tid VARCHAR(100) PRIMARY KEY,
    aid VARCHAR(100),
    title VARCHAR(200),
    FOREIGN KEY (aid) REFERENCES assessment(aid)
);

CREATE TABLE submission (
    sid VARCHAR(100) PRIMARY KEY AUTO_INCREMENT,
    tid VARCHAR(100),
    username VARCHAR(100),
    code VARCHAR(1000),
    attempt_no INT,
    score FLOAT(3),
    submitted_at DATETIME(200),
    FOREIGN KEY (tid) REFERENCES task(tid),
    FOREIGN KEY (username) REFERENCES session(username)
);

INSERT INTO students (username, password_hash)
    VALUES
    ('ben', '6edfe0531855295c5541d2666d604463'),
    ('benn', 'ea2b11c7e6bc373c628be113847b039d'),
    ('sasi', 'aa6bfe8bcf6eb51f7e158d8e5101fb71'),
    ('tricia', '0b4d4ee0c8e3cda51616f1f6cc64a655'),
    ('zongyu', '6e4a828704323be31656ec168be89920');