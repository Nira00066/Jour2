-- TP SQL – Requêtes 
USE cours;
 
/* ========== 1) Statistiques Utilisateurs ========== */
/* a) Nombre total d'utilisateurs */
SELECT COUNT(*) AS total_utilisateurs
FROM users;

/* b) Liste des utilisateurs avec nb d’inscriptions (y compris 0) */
SELECT u.id, u.name, u.email,
       COALESCE(COUNT(e.id), 0) AS nb_inscriptions
FROM users u
LEFT JOIN enrollments e ON e.user_id = u.id
GROUP BY u.id, u.name, u.email
ORDER BY u.id;

/* c) Moyenne d’inscriptions par utilisateur */
SELECT AVG(t.nb) AS moyenne_inscriptions_par_utilisateur
FROM (
  SELECT u.id, COUNT(e.id) AS nb
  FROM users u
  LEFT JOIN enrollments e ON e.user_id = u.id
  GROUP BY u.id
) AS t;

/* d) Liste des utilisateurs avec leur date d’inscription la plus ancienne */
SELECT u.id, u.name,
       MIN(e.enrolled_at) AS premiere_inscription
FROM users u
LEFT JOIN enrollments e ON e.user_id = u.id
GROUP BY u.id, u.name
ORDER BY u.id;

/* e) Nombre d’inscriptions par date (YYYY-MM-DD) */
SELECT DATE(enrolled_at) AS jour, COUNT(*) AS nb
FROM enrollments
GROUP BY DATE(enrolled_at)
ORDER BY jour;

/* ========== 2) Analyse des Cours ========== */
/* a) Nombre de cours par catégorie */
SELECT category, COUNT(*) AS nb_cours
FROM courses
GROUP BY category
ORDER BY category;

/* b) Prix moyen par catégorie */
SELECT category, ROUND(AVG(price), 2) AS prix_moyen
FROM courses
GROUP BY category
ORDER BY category;

/* c) Cours le moins cher et le plus cher (2 requêtes simples) */
-- moins cher
SELECT id, title, price
FROM courses
ORDER BY price ASC, id ASC
LIMIT 1;
-- plus cher
SELECT id, title, price
FROM courses
ORDER BY price DESC, id ASC
LIMIT 1;

/* d) Nombre d’inscriptions par cours (avec titre) */
SELECT c.id, c.title, COUNT(e.id) AS nb_inscriptions
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id, c.title
ORDER BY nb_inscriptions DESC, c.id;

/* ========== 3) Revenu de la plateforme ========== */
/* a) Revenu total (somme des prix des cours inscrits) */
SELECT ROUND(SUM(c.price), 2) AS revenu_total
FROM enrollments e
JOIN courses c ON c.id = e.course_id;

/* b) Revenu total par cours */
SELECT c.id, c.title, ROUND(SUM(c.price), 2) AS revenu
FROM enrollments e
JOIN courses c ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY revenu DESC;

/* c) Revenu total par catégorie */
SELECT c.category, ROUND(SUM(c.price), 2) AS revenu
FROM enrollments e
JOIN courses c ON c.id = e.course_id
GROUP BY c.category
ORDER BY revenu DESC;

/* d) Revenu moyen par utilisateur inscrit */
SELECT ROUND(AVG(t.revenu_utilisateur), 2) AS revenu_moyen_par_utilisateur_inscrit
FROM (
  SELECT e.user_id, SUM(c.price) AS revenu_utilisateur
  FROM enrollments e
  JOIN courses c ON c.id = e.course_id
  GROUP BY e.user_id
) AS t;

/* ========== 4) Notes et Avis ========== */
/* a) Moyenne des notes par cours */
SELECT c.id, c.title, ROUND(AVG(r.rating), 2) AS note_moyenne, COUNT(r.id) AS nb_avis
FROM courses c
LEFT JOIN reviews r ON r.course_id = c.id
GROUP BY c.id, c.title
ORDER BY note_moyenne DESC, nb_avis DESC;

/* b) Moyenne des notes par utilisateur */
SELECT u.id, u.name, ROUND(AVG(r.rating), 2) AS note_moyenne, COUNT(r.id) AS nb_avis
FROM users u
LEFT JOIN reviews r ON r.user_id = u.id
GROUP BY u.id, u.name
ORDER BY note_moyenne DESC;

/* c) Top 3 des cours les mieux notés (tri par moyenne puis nb_avis) */
SELECT c.id, c.title,
       ROUND(AVG(r.rating), 2) AS note_moyenne,
       COUNT(r.id) AS nb_avis
FROM courses c
LEFT JOIN reviews r ON r.course_id = c.id
GROUP BY c.id, c.title
HAVING nb_avis > 0
ORDER BY note_moyenne DESC, nb_avis DESC
LIMIT 3;

/* d) Nombre d’avis par cours */
SELECT c.id, c.title, COUNT(r.id) AS nb_avis
FROM courses c
LEFT JOIN reviews r ON r.course_id = c.id
GROUP BY c.id, c.title
ORDER BY nb_avis DESC, c.id;