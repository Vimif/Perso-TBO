# Importer le module manquant pour la cmdlet Get-View
Import-Module VMware.VimAutomation.Core
Import-Module .\Fonction_Search.psm1
Import-Module .\Fonction_Log.psm1

# Variables génériques
$serveurAdresse = "192.168.127.128"
$nomUtilisateur = "root"
$motDePasse = "Password5*"

# Demander à l'utilisateur de spécifier la commande
$nomCommande = Read-Host "Entrez la commande à exécuter"

# Se connecter au serveur vCenter
Connect-VIServer -Server $serveurAdresse -User $nomUtilisateur -Password $motDePasse

# Exécuter la commande et sélectionner la propriété 'Name'
$liste = & $nomCommande | Select-Object -Property Name

# Afficher la propriété 'Name' sous forme de tableau
& $nomCommande | Format-Table -Property Name

# Demander à l'utilisateur de choisir un datastore
$choix = & $nomCommande | Select-Object -Property Name
$choixSelectionne = Read-Host "Sélectionnez un choix ou écrivez 'all' si vous souhaitez tout obtenir"

# Vérifier si le datastore sélectionné existe
$choixValide = $choix | Where-Object { $liste.Name -eq "$choixSelectionne" }

if ($choixValide) {
    # Construire la commande pour sélectionner le datastore choisi
    $commande = "$nomCommande -Name '$choixSelectionne' | Select-Object -First 1"
    $selectionne = Invoke-Expression $commande
    $chVue = Get-View $selectionne

    Write-Verbose "Exploration des propriétés de l'objet obtenu à partir de la commande '$nomCommande':"
    Search-ObjectProperty -Object $chVue

    # Demander à l'utilisateur la valeur de recherche
    $valeurRecherchee = Read-Host "Entrez la valeur à rechercher"

    # Rechercher la valeur dans l'objet
    $resultatsRecherche = Search-ObjectProperty -Object $chVue -Value $valeurRecherchee

    if ($resultatsRecherche) {
        Write-Verbose "Propriétés correspondantes :"
        $resultatsRecherche | ForEach-Object { Write-Verbose "- $_" }
    } else {
        Write-Verbose "Aucune propriété correspondante trouvée."
    }
} else {
    Write-Verbose "Aucune propriété correspondante trouvée."
}