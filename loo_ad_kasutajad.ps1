# Impordime Active Directory mooduli
Import-Module ActiveDirectory

# Kasutajate nimekirja fail (muuda vajadusel)
$kasutajadFail = "C:\Users\marek\skriptid\kasutajad.txt"

# Kontrollime, kas fail on olemas
if (-Not (Test-Path $kasutajadFail)) {
    Write-Host "Viga: Kasutajate nimekirja faili ei leitud ($kasutajadFail)" -ForegroundColor Red
    exit 1
}

# Loeme kasutajate andmed failist
$kasutajad = Get-Content $kasutajadFail

foreach ($rida in $kasutajad) {
    # Jagame eesnime ja perenime
    $andmed = $rida -split "\s+"
    if ($andmed.Count -lt 2) {
        Write-Host "Viga: Vigane kasutaja andmete formaat failis - '$rida'" -ForegroundColor Red
        continue
    }

    $eesnimi = $andmed[0]
    $perenimi = $andmed[1]
    $kasutajanimi = "$eesnimi.$perenimi".ToLower()
    $taisNimi = "$eesnimi $perenimi"

    # Kontrollime, kas kasutaja on juba olemas AD-s
    $kasutajaOlemas = Get-ADUser -Filter {SamAccountName -eq $kasutajanimi} -ErrorAction SilentlyContinue

    if ($kasutajaOlemas) {
        Write-Host "Kasutaja '$kasutajanimi' on juba Active Directorys olemas. Lisamine ei ole vajalik." -ForegroundColor Yellow
        continue
    }

    # Määrame parooli
    $parool = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

    try {
        # Loome uue kasutaja
        New-ADUser -SamAccountName $kasutajanimi `
                   -UserPrincipalName "$kasutajanimi@mukri.sise" `
                   -Name $taisNimi `
                   -GivenName $eesnimi `
                   -Surname $perenimi `
                   -DisplayName $taisNimi `
                   -Path "OU=Users,DC=mukri,DC=sise" `
                   -AccountPassword $parool `
                   -Enabled $true `
                   -PassThru `
                   -ErrorAction Stop
        Write-Host "Kasutaja '$kasutajanimi' on edukalt lisatud Active Directorysse." -ForegroundColor Green
    } catch {
        Write-Host "Viga: Kasutaja '$kasutajanimi' lisamine ebaõnnestus." -ForegroundColor Red
        Write-Host "Veateade: $_" -ForegroundColor Yellow
        continue
    }

    # Kontrollime, kas lisamine õnnestus
    if ($?) {
        Write-Host "Kasutaja '$kasutajanimi' on nüüd Active Directorys olemas!" -ForegroundColor Green
    } else {
        Write-Host "Viga: Kasutaja '$kasutajanimi' lisamine ei õnnestunud." -ForegroundColor Red
    }
}

