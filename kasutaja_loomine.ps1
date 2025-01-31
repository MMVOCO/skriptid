# Küsi kasutajalt eesnimi ja perekonnanimi
$firstName = Read-Host "Sisesta eesnimi (ladina tähestikus)"
$lastName = Read-Host "Sisesta perekonnanimi (ladina tähestikus)"

# Muuda nimi väikesteks tähtedeks ja loo kasutajanimi vormingus "ees.perenimi"
$username = "$firstName.$lastName".ToLower()
$fullName = "$firstName $lastName"

# Kontrolli, kas kasutaja juba eksisteerib
$userExists = Get-LocalUser | Where-Object { $_.Name -eq $username }

if ($userExists) {
    Write-Host "Viga: Kasutaja '$username' on juba olemas." -ForegroundColor Red
    exit 1
}

# Määra parool (Parool1!)
$password = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

# Proovi kasutaja luua
try {
    # Loo uus lokaalne kasutaja
    New-LocalUser -Name $username -FullName $fullName -Description "Lokaalne kasutaja" -Password $password -ErrorAction Stop
    Write-Host "Kasutaja '$username' on edukalt loodud." -ForegroundColor Green
} catch {
    # Kuvatakse veateade, kui loomine ebaõnnestus
    Write-Host "Viga: Kasutaja loomine ebaõnnestus. Kontrolli sisestatud andmeid." -ForegroundColor Red
    Write-Host "Veateade: $_" -ForegroundColor Yellow
    exit 1
}

# Kontrolli, kas kasutaja loomine oli edukas
if ($?) {
    Write-Host "Kasutaja '$username' loodi edukalt!" -ForegroundColor Green
} else {
    Write-Host "Viga: Kasutaja loomine ebaõnnestus." -ForegroundColor Red
    exit 1
}
