-- Nombre total d'utilisateurs
SELECT
    COUNT(*)
FROM
    users;

-- Liste des utilisateurs avec leur nombre dʼinscriptions (y compris ceux à 0)
SELECT
    users.id,
    users.username,
    COUNT(enrollments.id) AS nbs_enroll
FROM
    enrollments
    LEFT JOIN enrollments ON users.id = enrollments.user_id
GROUP BY
    users.id,
    users.username
ORDER BY
    nbs_enroll DESC;

--  on veux une moyen de tout les user par rapport au cours 
--  select count * from user 
SELECT
    AVG(nb_inscriptions) AS moyenne_inscriptions_par_utilisateur
FROM
    (
        SELECT
            users.id,
            COUNT(enrollments.id) AS nb_inscriptions
        FROM
            users
            LEFT JOIN enrollments ON users.id = enrollments.user_id
        GROUP BY
            users.id
    ) AS sous_requete;

--  Liste des utilisateurs avec leur date d'inscription la plus ancienne 
SELECT
    users.username,
    users.id,
    created_at
FROM
    users
ORDER BY
    created_at DESC;

--  nombre d'insciption par date 
SELECT
    e.id,
    e.user_id,
    e.completed_at
FROM
    enrollments e
ORDER BY
    completed_at DESC;

-- BONUS  
--  TOP 3 des users ayant completer le plus de cours 
SELECT
    users.id,
    COUNT(enrollments.id) AS nb_inscriptions
    
LIMIT
    3;

    