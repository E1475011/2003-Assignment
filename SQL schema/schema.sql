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
    aid VARCHAR(100) FOREIGN KEY,
    title VARCHAR(200)
);

CREATE TABLE submission (
    sid VARCHAR(100) PRIMARY KEY,
    tid VARCHAR(100) FOREIGN KEY,
    username VARCHAR(100) FOREIGN KEY,
    code VARCHAR(1000),
    attempt_no INT,
    score FLOAT(3),
    submitted_at DATETIME(200)
);