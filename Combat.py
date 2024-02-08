# Exercice : Créez un jeu de combat en Python

#     Créez deux classes, une pour chaque combattant. Chaque classe devrait avoir les attributs suivants :
#         nom : Le nom du combattant.
#         points_de_vie : Les points de vie du combattant (par exemple, 100).
#         degats : Les dégâts de base infligés par le combattant à chaque attaque (par exemple, 10).
#         attaque_speciale : Les dégâts infligés lors de l'attaque spéciale (par exemple, 20).

#     Écrivez une méthode attaquer() dans chaque classe qui permet au combattant d'attaquer son adversaire. Lorsqu'un combattant attaque, les points de vie de l'adversaire devraient être réduits en fonction de ses dégâts.

#     Écrivez une méthode attaque_speciale() dans chaque classe qui permet au combattant d'effectuer une attaque spéciale. Cette attaque spéciale inflige plus de dégâts que l'attaque normale.

#     Dans le programme principal, créez deux instances de combattants avec des noms et des attributs de votre choix.

#     Écrivez une boucle qui simule le combat entre les deux combattants. Les combattants devraient alterner entre l'attaque normale et l'attaque spéciale à chaque tour. Affichez le résultat de chaque tour, y compris les points de vie restants.

#     La boucle continue jusqu'à ce que l'un des combattants ait des points de vie égaux ou inférieurs à zéro. À ce moment, affichez le nom du vainqueur. 

##############################################################################################################################################################################################

class Attribut:
    vie_joueur = float(100)
    degat = float(10)
    attaque_special = float(20)

    def  tkt(self):
        return "ma bite"
    