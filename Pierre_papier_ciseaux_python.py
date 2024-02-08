import random

liste_choix = ["pierre", "papier", "ciseaux"]

while True :

    joueur = (input("Choisis entre pierre, papier, ciseaux : "))
    ordinateur = random.choice(liste_choix)

    if joueur == "pierre" and ordinateur == "pierre" :
        print ("égalité")
    elif joueur == "pierre" and ordinateur == "papier" :
        print("perdu")
    elif joueur == "pierre" and ordinateur == "ciseaux" :
        print("gagné")
    elif joueur == "ciseaux" and ordinateur == "ciseaux" :
        print("égalité")
    elif joueur == "ciseaux" and ordinateur == "papier" :
        print("gagné")
    elif joueur == "ciseaux" and ordinateur == "pierre" :
        print("perdu")
    elif joueur == "papier" and ordinateur == "papier" :
        print("égalité")
    elif joueur == "papier" and ordinateur == "ciseaux" :
        print("perdu")
    elif joueur == "papier" and ordinateur == "pierre" :
        print("gagné")

    reponse = input("Voulez-vous jouer à nouveau ? (Oui/Non) : " )
    if reponse.lower() != "oui" :
        break
