# TP SQL – Plateforme de cours en ligne (statistiques)

## Contexte
Analyse d’une plateforme e-learning en SQL : modéliser, alimenter et requêter.  
Livrables : scripts SQL + README.

## Modèle de données
4 tables relationnelles avec PK/FK :
- **users**(id PK, name, email, created_at)
- **courses**(id PK, title, category, price)
- **enrollments**(id PK, user_id FK→users, course_id FK→courses, enrolled_at, completed, completed_at)
- **reviews**(id PK, user_id FK→users, course_id FK→courses, rating 1..5, comment)

Contraintes principales :
- `price >= 0` ; `rating BETWEEN 1 AND 5`
- si `completed = 1` ⇒ `completed_at` non NULL et `completed_at >= enrolled_at`

## Données insérées
- 20 utilisateurs, 12 cours (plusieurs catégories), 50 inscriptions, 12 avis.

## Requêtes fournies
1. **Utilisateurs** : total, nb d’inscriptions (y compris 0), moyenne par utilisateur, première inscription, nb par date.  
2. **Cours** : nb par catégorie, prix moyen par catégorie, moins cher / plus cher, nb d’inscriptions par cours.  
3. **Revenu** : total, par cours, par catégorie, moyen par utilisateur inscrit.  
4. **Notes & Avis** : moyenne par cours, moyenne par utilisateur, top 3 des cours, nb d’avis par cours.

## Exécution
1. `sql/cours_schema.sql`  → crée la BD **cours** et les tables  
2. `sql/cours_seed.sql`    → insère les données minimales  
3. `sql/cours_queries.sql` → lance les statistiques