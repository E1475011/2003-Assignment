SELECT * FROM submission WHERE submitted_at BETWEEN '2025-07-01' AND '2025-08-01'; 
<!--old and new due date-->

UPDATE submission SET score = score / 9 * 10 WHERE submitted_at BETWEEN '2025-07-01' AND '2025-08-01';
<!--duedate is push later-->
UPDATE submission SET score = score / 10 * 9 WHERE submitted_at BETWEEN '2025-07-01' AND '2025-08-01';
<!--duedate is push earlier-->
<!--show updated score-->

update assessment set due_date = '2025-07-04' WHERE aid = '1';
<!-- to update duedate for specific assessment-->