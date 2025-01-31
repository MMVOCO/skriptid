# Küsi kasutajalt eesnimi ja perekonnanimi
$firstName = Read-Host "Sisesta eesnimi (ladina tähestikus)"
$lastName = Read-Host "Sisesta perekonnanimi (ladina tähestikus)"

# Loo kasutajanimi samamoodi nagu eelmises ülesandes
$username = "$firstName.$lastName".ToLower()

# Kontrolli, kas kasutaja eksisteerib
$userExists = Get-LocalUser | Where-Object { $_.Name -eq $username }

if ($userExists) {
    try {
        # Proovi kasutaja kustutada
        Remove-LocalUser -Name $username -ErrorAction Stop
        Write-Host "Kasutaja '$username' on edukalt kustutatud." -ForegroundColor Green
    } catch {
        Write-Host "Viga: Kasutaja '$username' kustutamine ebaõnnestus." -ForegroundColor Red
        Write-Host "Veateade: $_" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "Viga: Kasutajat '$username' ei leitud." -ForegroundColor Red
    exit 1
}

# Kontrollime, kas kasutaja on edukalt kustutatud
$userCheck = Get-LocalUser | Where-Object { $_.Name -eq $username }

if (-not $userCheck) {
    Write-Host "Kasutaja '$username' on süsteemist eemaldatud!" -ForegroundColor Green
} else {
    Write-Host "Viga: Kasutaja '$username' kustutamine ei õnnestunud." -ForegroundColor Red
    exit 1
}
