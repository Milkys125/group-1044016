#!/bin/bash

# Chemin vers le fichier CSV
file="users.csv"

# 1. Nombre total d'utilisateurs (on exclut l'en-tête)
total_users=$(tail -n +2 "$file" | wc -l)

# 2. Nombre d'utilisateurs par genre
echo "Nombre d'utilisateurs par genre :"
tail -n +2 "$file" | awk -F',' '{print $3}' | sort | uniq -c

# 3. Dernier utilisateur à s'être connecté
last_user=$(tail -n +2 "$file" | sort -t, -k4 -r | head -n 1)
first_name=$(echo "$last_user" | awk -F',' '{print $1}')
last_name=$(echo "$last_user" | awk -F',' '{print $2}')
last_login=$(echo "$last_user" | awk -F',' '{print $4}')

# Affichage des résultats
echo "Nombre total d'utilisateurs : $total_users"
echo "Le dernier utilisateur à s'être connecté : $first_name $last_name ($last_login)"