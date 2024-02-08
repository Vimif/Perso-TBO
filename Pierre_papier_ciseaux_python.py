import random  # Importe le module random pour générer des choix aléatoires

# Liste des choix possibles dans le jeu
liste_choix = ["pierre", "papier", "ciseaux"]

# Boucle principale du jeu
while True:
    # Le joueur fait son choix
    joueur = input("Choisis entre pierre, papier, ciseaux : ")
    # L'ordinateur fait un choix aléatoire
    ordinateur = random.choice(liste_choix)

    # Les conditions suivantes déterminent le résultat du jeu en fonction des choix du joueur et de l'ordinateur
    if joueur == "pierre" and ordinateur == "pierre":
        print("Égalité")
    elif joueur == "pierre" and ordinateur == "papier":
        print("Perdu")
    elif joueur == "pierre" and ordinateur == "ciseaux":
        print("Gagné")
    elif joueur == "ciseaux" and ordinateur == "ciseaux":
        print("Égalité")
    elif joueur == "ciseaux" and ordinateur == "papier":
        print("Gagné")
    elif joueur == "ciseaux" and ordinateur == "pierre":
        print("Perdu")
    elif joueur == "papier" and ordinateur == "papier":
        print("Égalité")
    elif joueur == "papier" and ordinateur == "ciseaux":
        print("Perdu")
    elif joueur == "papier" and ordinateur == "pierre":
        print("Gagné")

    # Demande au joueur s'il veut jouer à nouveau
    reponse = input("Voulez-vous jouer à nouveau ? (Oui/Non) : ")
    # Si la réponse n'est pas "oui", on sort de la boucle et le jeu se termine
    if reponse.lower() != "oui":
        break