# Määrame varunduse kausta
$backupFolder = "C:\Backup"

# Loome varunduse kausta, kui seda pole
if (-Not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# Leiame kõik lokaalsed kasutajad
$kasutajad = Get-LocalUser | Where-Object { $_.Enabled -eq $true }

# Kuupäeva formaat varunduse failinimes
$kuupaev = Get-Date -Format "dd.MM.yyyy"

foreach ($kasutaja in $kasutajad) {
    $kasutajanimi = $kasutaja.Name
    $kasutajaKodu = "C:\Users\$kasutajanimi"

    # Kontrollime, kas kodukataloog eksisteerib
    if (Test-Path $kasutajaKodu) {
        $sihtFail = "$backupFolder\$kasutajanimi-$kuupaev.zip"

        try {
            # Loome ZIP arhiivi
            Compress-Archive -Path "$kasutajaKodu\*" -DestinationPath $sihtFail -Force
            Write-Host "Kasutaja '$kasutajanimi' kodukataloog on varundatud: $sihtFail" -ForegroundColor Green
        } catch {
            Write-Host "Viga: Ei õnnestunud varundada kasutaja '$kasutajanimi' kodukataloogi." -ForegroundColor Red
            Write-Host "Veateade: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Hoiatus: Kasutajal '$kasutajanimi' ei ole kodukataloogi." -ForegroundColor Yellow
    }
}

Write-Host "Kõikide kasutajate varundamine on lõpetatud!" -ForegroundColor Cyan
