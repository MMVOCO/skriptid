# Kasutajate nimekirja fail
$kasutajadFail = "C:\Users\marek\skriptid\kasutajad.txt"

# CSV faili salvestamise asukoht
$csvFail = "C:\Users\marek\skriptid\kasutajad_paroolid.csv"

# Parooli genereerimise funktsioon
function Genereeri-Parool {
    $parooliPikkus = 12
    $charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
    -join ((1..$parooliPikkus) | ForEach-Object { Get-Random -InputObject $charSet.ToCharArray() })
}

# Kontrollime, kas fail on olemas
if (-Not (Test-Path $kasutajadFail)) {
    Write-Host "Viga: Kasutajate nimekirja faili ei leitud ($kasutajadFail)" -ForegroundColor Red
    exit 1
}

# Loeme kasutajate andmed failist
$kasutajad = Get-Content $kasutajadFail
$paroolideNimekiri = @()

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

    # Kontrollime, kas kasutaja on juba olemas
    $kasutajaOlemas = Get-LocalUser | Where-Object { $_.Name -eq $kasutajanimi }

    if ($kasutajaOlemas) {
        Write-Host "Kasutaja '$kasutajanimi' on juba olemas. Lisamine ei ole vajalik." -ForegroundColor Yellow
        continue
    }

    # Genereerime juhusliku parooli
    $parool = Genereeri-Parool
    $paroolSecure = ConvertTo-SecureString $parool -AsPlainText -Force

    try {
        # Loome uue lokaalse kasutaja
        New-LocalUser -Name $kasutajanimi -FullName $taisNimi -Password $paroolSecure -Description "Lokaalne kasutaja"
        Write-Host "Kasutaja '$kasutajanimi' on edukalt loodud!" -ForegroundColor Green

        # Lisame kasutajanime ja parooli nimekirja
        $paroolideNimekiri += [PSCustomObject]@{
            Kasutajanimi = $kasutajanimi
            Parool       = $parool
        }
    } catch {
        Write-Host "Viga: Kasutaja '$kasutajanimi' loomine ebaõnnestus." -ForegroundColor Red
        Write-Host "Veateade: $_" -ForegroundColor Yellow
        continue
    }
}

# Salvestame kasutajate nimekirja ja paroolid CSV-faili
if ($paroolideNimekiri.Count -gt 0) {
    $paroolideNimekiri | Export-Csv -Path $csvFail -NoTypeInformation -Encoding UTF8
    Write-Host "Kasutajate paroolid on salvestatud faili: $csvFail" -ForegroundColor Cyan
}
