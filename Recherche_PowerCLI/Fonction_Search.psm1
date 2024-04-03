# Cette fonction recherche une valeur spécifique dans toutes les propriétés d'un objet donné.
function Search-ObjectProperty {
    # Définition des paramètres de la fonction
    param(
        [Parameter(Mandatory)]
        [psobject]$Object,  # L'objet dans lequel effectuer la recherche

        [string]$Value,  # La valeur à rechercher

        [int]$MaxDepth = 20,  # La profondeur maximale de la recherche récursive

        [string]$CurrentPath = '',  # Le chemin actuel de la propriété

        [int]$CurrentDepth = 0,  # La profondeur actuelle de la recherche

        [System.Collections.Generic.HashSet[string]]$VisitedPaths = [System.Collections.Generic.HashSet[string]]::new()  # Les chemins de propriété déjà visités
    )

    # Initialisation du tableau de résultats
    $SearchResults = @()

    # Si l'objet est null, on retourne un tableau vide
    if ($Object -eq $null) {
        Write-Verbose "L'objet fourni est null."
        return $SearchResults
    }

    # On effectue la recherche seulement si la profondeur actuelle est inférieure ou égale à la profondeur maximale
    if ($CurrentDepth -le $MaxDepth) {
        $Properties = @()
        try {
            # Si l'objet est une référence d'objet gérée VMware, on obtient ses propriétés via Get-View
            if ($Object -is [VMware.Vim.ManagedObjectReference]) {
                $View = Get-View -Id $Object -ErrorAction SilentlyContinue
                $Properties = $View.PSObject.Properties.Name
            } else {
                # Sinon, on obtient directement les propriétés de l'objet
                $Properties = $Object.PSObject.Properties.Name
            }
        } catch {
            Write-Verbose "Erreur lors de la tentative d'obtenir des vues ou des propriétés de l'objet : $_"
        }

        # Pour chaque propriété de l'objet
        foreach ($PropertyName in $Properties) {
            # On obtient la valeur de la propriété
            $PropertyValue = $Object.$PropertyName
            # On construit le chemin de la propriété
            $PropertyPath = if ($CurrentPath -eq '') { $PropertyName } else { "$CurrentPath.$PropertyName" }

            # Si le chemin de la propriété n'a pas encore été visité
            if (-not $VisitedPaths.Contains($PropertyPath)) {
                # On ajoute le chemin à la liste des chemins visités
                $VisitedPaths.Add($PropertyPath) | Out-Null

                $StringValue = $null
                try {
                    # On convertit la valeur de la propriété en chaîne de caractères
                    $StringValue = $PropertyValue -join ','
                } catch {
                    continue
                }

                # Si la valeur de la propriété correspond à la valeur recherchée, on ajoute le chemin de la propriété aux résultats
                if ($StringValue -match $Value) {
                    $SearchResults += $PropertyPath
                }

                # Si la valeur de la propriété est un objet et n'est ni une chaîne de caractères ni une valeur de type, on effectue une recherche récursive dans ses propriétés
                if ($PropertyValue -is [System.Object] -and -not ($PropertyValue -is [string]) -and -not ($PropertyValue -is [ValueType])) {
                    $NestedResults = Search-ObjectProperty -Object $PropertyValue -Value $Value -MaxDepth $MaxDepth -CurrentPath $PropertyPath -CurrentDepth ($CurrentDepth + 1) -VisitedPaths $VisitedPaths
                    $SearchResults += $NestedResults
                }
            }
        }
    }

    # On retourne les résultats de la recherche
    return $SearchResults
}

Export-ModuleMember -Function 'Search-ObjectProperty'