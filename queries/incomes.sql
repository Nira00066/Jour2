--  1. Revenu total généré
SELECT  
  SUM(c.price) AS revenu_total
FROM courses c 
JOIN enrollments e ON c.id = e.course_id;

--  2. Revenu par cours
SELECT  
  c.title,
  COUNT(e.id) AS nombre_inscriptions,
  ROUND(COUNT(e.id) * c.price, 2) AS revenu_par_cours
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.title, c.price
ORDER BY revenu_par_cours DESC;

--  3. Revenu par catégorie
SELECT  
  c.category,
  COUNT(e.id) AS nombre_inscriptions,
  ROUND(COUNT(e.id) * c.price, 2) AS revenu_par_categorie
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.category
ORDER BY revenu_par_categorie DESC;

--  4. Revenu moyen par utilisateur inscrit
SELECT   
  ROUND(SUM(c.price) / COUNT(DISTINCT e.user_id), 2) AS revenu_par_inscrit
FROM courses c 
JOIN enrollments e ON c.id = e.course_id;

