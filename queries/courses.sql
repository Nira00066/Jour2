--  1. Nombre de cours par catégorie
SELECT 
  category,
  COUNT(*) AS nombre_de_cours
FROM courses
GROUP BY category
ORDER BY nombre_de_cours DESC;

--  2. Prix moyen par catégorie
SELECT
  category,
  ROUND(AVG(c.price), 2) AS prix_moyen_par_categorie
FROM courses c
GROUP BY c.category 
ORDER BY prix_moyen_par_categorie DESC;

-- 3. Cours le moins cher
SELECT 
  title AS cours_le_moins_cher, 
  price
FROM courses
WHERE price = (SELECT MIN(price) FROM courses);

--  4. Cours le plus cher
SELECT 
  title AS cours_le_plus_cher, 
  price
FROM courses
WHERE price = (SELECT MAX(price) FROM courses);

-- 5. Nombre d'inscriptions par cours
SELECT 
  c.id,
  c.title,
  COUNT(e.id) AS nombre_inscriptions
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY nombre_inscriptions DESC;
