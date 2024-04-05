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
class Combattant:
    def __init__(self, nom, points_de_vie, degats, attaque_speciale):
        self.nom = nom
        self.points_de_vie = points_de_vie
        self.degats = degats
        self.attaque_speciale = attaque_speciale

    def attaquer(self, adversaire):
        adversaire.points_de_vie -= self.degats

    def attaque_speciale(self, adversaire):
        adversaire.points_de_vie -= self.attaque_speciale

# Création des instances de combattants
combattant1 = Combattant("Combattant 1", 100, 10, 20)
combattant2 = Combattant("Combattant 2", 100, 10, 20)

# Boucle de combat
while combattant1.points_de_vie > 0 and combattant2.points_de_vie > 0:
    # Combattant 1 attaque Combattant 2
    combattant1.attaquer(combattant2)
    print(f"{combattant1.nom} attaque {combattant2.nom}. Points de vie restants de {combattant2.nom}: {combattant2.points_de_vie}")
    
    # Vérification si Combattant 2 est toujours en vie
    if combattant2.points_de_vie <= 0:
        print(f"{combattant1.nom} a vaincu {combattant2.nom}!")
        break
    
    # Combattant 2 attaque Combattant 1
    combattant2.attaquer(combattant1)
    print(f"{combattant2.nom} attaque {combattant1.nom}. Points de vie restants de {combattant1.nom}: {combattant1.points_de_vie}")
    
    # Vérification si Combattant 1 est toujours en vie
    if combattant1.points_de_vie <= 0:
        print(f"{combattant2.nom} a vaincu {combattant1.nom}!")
        break
    