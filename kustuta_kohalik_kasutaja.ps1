# Küsi kasutajalt eesnimi ja perekonnanimi
$eesnimi = Read-Host "Sisesta eesnimi"
$perenimi = Read-Host "Sisesta perekonnanimi"

# Loo kasutajanimi (väiketähtedeks ja punkt vahel)
$kasutajanimi = "$eesnimi.$perenimi".ToLower()

# Kontrollime, kas kasutaja on olemas
$kasutajaOlemas = Get-LocalUser | Where-Object { $_.Name -eq $kasutajanimi }

if ($kasutajaOlemas) {
    try {
        # Kustutame kasutaja
        Remove-LocalUser -Name $kasutajanimi -ErrorAction Stop
        Write-Host "Kasutaja '$kasutajanimi' on edukalt kustutatud." -ForegroundColor Green
    } catch {
        Write-Host "Viga: Kasutaja '$kasutajanimi' kustutamine ebaõnnestus." -ForegroundColor Red
        Write-Host "Veateade: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "Viga: Kasutajat '$kasutajanimi' ei leitud." -ForegroundColor Red
}
