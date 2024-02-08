import random

liste_choix = ["pierre", "papier", "ciseaux"]

while True:
    joueur = input("Choisis entre pierre, papier, ciseaux : ")
    ordinateur = random.choice(liste_choix)

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

    reponse = input("Voulez-vous jouer à nouveau ? (Oui/Non) : ")
    if reponse.lower() != "oui":
        break