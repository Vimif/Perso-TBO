function Connect-ESXiServer {
    param (
        [string]$esxiHost = $env:GITHUB_ESXIHOST,  # ESXi host IP address from GitHub secret/environment variable
        [string]$esxiUsername = $env:GITHUB_ESXIUSERNAME,  # ESXi host username from GitHub secret/environment variable
        [string]$esxiPassword = $env:GITHUB_ESXIPASSWORD # ESXi host password from GitHub secret/environment variable
    )
    
    # Validation des paramètres
    if (-not $esxiHost -or -not $esxiUsername -or -not $esxiPassword) {
        Write-Output "Un ou plusieurs paramètres de connexion sont manquants."
        return $false
    }
    
    try {
        # Se connecter au serveur ESXi
        $esxiSession = Connect-VIServer -Server $esxiHost -User $esxiUsername -Password $esxiPassword 
        
        # Vérifier si la connexion a réussi
        if ($esxiSession) {
            Write-Output "Connexion au serveur ESXi réussie."
            return $true
        } else {
            Write-Output "Échec de la connexion au serveur ESXi."
            return $false
        }
    } catch {
        Write-Output "Une erreur s'est produite lors de la connexion au serveur ESXi : $_"
        return $false
    }
}