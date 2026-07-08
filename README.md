\# 📚 Mon Projet Cours – Application de Gestion de Cours



Application mobile développée avec \*\*Flutter\*\*, permettant la gestion de matières et de cours scolaires, avec authentification et stockage en temps réel via \*\*Firebase\*\*.



Projet réalisé dans le cadre d'un travail académique à \*\*ISEP Thiès\*\*.



\---



\## 🎯 Objectif du projet



Créer une application permettant :

\- À un \*\*administrateur\*\* de créer, modifier et supprimer des matières et des cours.

\- Au \*\*grand public\*\* (utilisateurs non-admin) de consulter librement les matières et cours disponibles, en lecture seule.



\---



\## ✨ Fonctionnalités



\- 🔐 \*\*Authentification\*\* des utilisateurs (Firebase Authentication)

\- 📖 \*\*Gestion des matières\*\* : ajout, modification, suppression, consultation

\- 📝 \*\*Gestion des cours\*\* : ajout, modification, suppression, consultation, associés à une matière

\- 🏷️ Niveaux de cours (Débutant / Intermédiaire / Avancé)

\- 👨‍🏫 Attribution d'un professeur et d'une durée à chaque cours

\- 🔄 Mise à jour en temps réel des données grâce aux \*\*Streams Firestore\*\*

\- 🔒 Droits d'accès différenciés : écriture réservée à l'admin, lecture publique

\- 🖼️ (Extension prévue) Stockage d'images de matières et de fichiers PDF de cours via Firebase Storage



\---



\## 🛠️ Technologies utilisées



| Catégorie | Technologie |

|---|---|

| Framework | Flutter (Dart) |

| Gestion d'état | Riverpod |

| Backend / Base de données | Firebase Firestore |

| Authentification | Firebase Authentication |

| Stockage fichiers | Firebase Storage |

| Versionning | Git / GitHub |

| IDE | Android Studio |



\---



\## 🏗️ Architecture du projet



```

lib/

├── models/            # Modèles de données (Matiere, Cours)

├── providers/          # Providers Riverpod (state management)

├── services/            # Services Firebase (FirestoreService, AuthService)

├── screens/            # Écrans de l'application (UI)

└── main.dart            # Point d'entrée de l'application

```



\---



\## 🚀 Installation et lancement



\### Prérequis

\- Flutter SDK installé

\- Un projet Firebase configuré (fichier `google-services.json` pour Android)

\- Un émulateur Android ou un appareil physique



\### Étapes



```bash

\# Cloner le dépôt

git clone https://github.com/diarrydiene6-web/mon\_projet\_cours.git



\# Se placer dans le dossier du projet

cd mon\_projet\_cours



\# Installer les dépendances

flutter pub get



\# Lancer l'application

flutter run

```



\---





\## 👩‍💻 Auteur



\*\*Ndeye Diarry Diene\*\*

Étudiante en développement web et mobile – ISEP Thiès

GitHub : \[@diarrydiene6-web](https://github.com/diarrydiene6-web)



\---



\## 📄 Licence



Projet réalisé à des fins pédagogiques dans le cadre d'un cours à ISEP Thiès.

