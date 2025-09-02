SELECT category, COUNT(*) AS total_courses
FROM courses
GROUP BY category;


SELECT category, AVG(price) AS prix_moyen
FROM courses
GROUP BY category;




SELECT * FROM courses ORDER BY price DESC;


SELECT c.id, c.title, COUNT(e.id) AS total_inscriptions
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.title;
