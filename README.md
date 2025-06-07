# Innov-Digital
Application mobile d’indexation intelligente multi-canal intégrant OCR, reconnaissance vocale et NLP pour la coédition collaborative et le classement automatisé de documents multimodaux.

# Fonctionnalités
- Upload multicanal : prise en charge des documents manuscrits, audio, image & PDF.
- Extraction automatique du contenu et des mots-clés, avec stockage dans une base de données SQL.
- Recherche intelligente via une barre de recherche ou un chatbot (texte ou vocal), basée sur les mots-clés extraits.
- Assistant vocal "Dexy" (modèle t5-base) qui compare les différentes versions d’un document, résume automatiquement les modifications et informe oralement l’utilisateur des dernières mises à jour.
- Affichage et résumé automatique des documents avec accès à l’historique des versions et possibilité de consulter une version spécifique.

# Structure du projet
- back-end/ : Contient le cœur du projet avec l’entraînement des modèles et le traitement des données.
- front-end/ : Contient l’interface de l’application mobile.

# Prérequis
- Flutter
- Python 3.7+
- Les packages : spacy, pillow, pytesseract, PyMuPDF, yake, whisper, torch, torchaudio & ffmpeg-python.

# Note
- Pour exécuter le projet, saisissez la commande `flutter run` dans le répertoire `front-end/` afin de lancer l’application mobile puis, dans un autre terminal, placez-vous dans le répertoire `back-end/` et exécutez la commande `python main.py` pour démarrer le serveur.
