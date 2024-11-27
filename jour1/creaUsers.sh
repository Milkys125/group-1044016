#!/bin/bash

# Vérifier si pwgen est installé, sinon l'installer
if ! command -v pwgen &> /dev/null; then
    echo "pwgen n'est pas installé. Installation en cours..."
    sudo apt-get update && sudo apt-get install -y pwgen
fi

# Fonction pour ajouter un utilisateur
add_user() {
    local USER_NAME=$1
    local HOME_DIR="/home/$USER_NAME"
    local SHELL="/bin/bash"
    local PASSWORD=$(pwgen 12 1)

    # Vérifier si l'utilisateur existe déjà
    if id "$USER_NAME" &>/dev/null; then
        echo "Utilisateur $USER_NAME existe déjà, skipping."
    else
        # Ajouter l'utilisateur avec home directory et shell
        sudo useradd -m -d "$HOME_DIR" -s "$SHELL" "$USER_NAME"

        # Définir le mot de passe de l'utilisateur
        echo "$USER_NAME:$PASSWORD" | sudo chpasswd

        # Afficher les détails de l'utilisateur créé
        echo "Utilisateur $USER_NAME ajouté avec succès."
        echo "Mot de passe : $PASSWORD"
        echo "Répertoire personnel : $HOME_DIR"
        echo "Shell : $SHELL"
        echo "------------------------------------"
    fi
}

# Vérifier si des arguments sont passés
if [ $# -eq 0 ]; then
    echo "Utilisation : $0 utilisateur1 utilisateur2 ... ou fournir un fichier texte avec la liste des utilisateurs"
    exit 1
fi

# Si un fichier est passé en argument
if [ -f "$1" ]; then
    while IFS= read -r user; do
        add_user "$user"
    done < "$1"
else
    # Ajouter chaque utilisateur passé en argument
    for user in "$@"; do
        add_user "$user"
    done
fi
