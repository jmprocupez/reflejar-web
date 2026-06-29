# Descarga todas las fotos de productos para el catálogo de Reflejar
# Correr desde VS Code terminal en la carpeta del proyecto

$imgDir = "C:\Users\jproc\Desktop\cotizador-reflejar\reflejar-web\img"
New-Item -ItemType Directory -Force -Path $imgDir | Out-Null
Write-Host "Carpeta img/ lista en: $imgDir" -ForegroundColor Green

$headers = @{
    "User-Agent"      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
    "Referer"         = "https://www.mampara.com.ar/"
    "Accept"          = "image/webp,image/apng,image/*,*/*;q=0.8"
    "Accept-Language" = "es-AR,es;q=0.9"
}

$base = "https://www.mampara.com.ar/"

# Función para codificar URL correctamente (UTF-8, sin doble-encoding)
function Encode-Url($s) {
    $s = $s -replace ' ',  '%20'
    $s = $s -replace 'ñ',  '%C3%B1'
    $s = $s -replace 'á',  '%C3%A1'
    $s = $s -replace 'é',  '%C3%A9'
    $s = $s -replace 'í',  '%C3%AD'
    $s = $s -replace 'ó',  '%C3%B3'
    $s = $s -replace 'ú',  '%C3%BA'
    $s = $s -replace 'Á',  '%C3%81'
    $s = $s -replace 'É',  '%C3%89'
    $s = $s -replace 'Ó',  '%C3%93'
    return $s
}

$imagenes = @(
    # CORREDIZAS — nombres con ñ, requieren encoding correcto
    @{ nombre="corrediza_4p_aluminio.webp"; url="Mampara Corrediza de cuatro paños en color aluminio-360.webp" }
    @{ nombre="corrediza_4p_negro.webp";    url="Mampara corrediza de cuatro paños en color negro-360.webp" }
    @{ nombre="corrediza_2p_aluminio.webp"; url="Mampara corrediza de dos paños en Aluminio-360.webp" }
    @{ nombre="corrediza_2p_negro.webp";    url="Mampara corrediza de dos paños en color negro-360.webp" }
    # FIJAS
    @{ nombre="fija_aluminio_plata.webp";   url="Mampara Fija con aluminio plata-360.webp" }
    @{ nombre="fija_aluminio_negro.webp";   url="Mampara Fija con aluminio negro-360.webp" }
    @{ nombre="fija_aluminio_blanco.webp";  url="Mampara Fija con aluminio blanco-360.webp" }
    @{ nombre="fija_brazo_tensor.webp";     url="Mampara Fija en aluminio con brazo tensor-360.webp" }
    @{ nombre="fija_acanalado.webp";        url="Mampara Fija en vidrio acanalado-360.webp" }
    @{ nombre="fija_laminado_bronce.webp";  url="Mampara Fija en vidrio laminado bronce-360.webp" }
    @{ nombre="fija_laminado_gris.webp";    url="Mampara Fija en vidrio laminado gris-360.webp" }
    @{ nombre="fija_laminado_opaco.webp";   url="Mampara Fija en vidrio laminado opaco-360.webp" }
    # REBATIBLES — con ñ
    @{ nombre="rebatible_3p_plata.webp";    url="Mampara Rebatible de tres paños en color plata-360.webp" }
    @{ nombre="rebatible_3p_negro.webp";    url="Mampara Rebatible de tres paños en color negro-360.webp" }
    @{ nombre="rebatible_2p_plata.webp";    url="Mampara Rebatible de dos paños en color plata-360.webp" }
    @{ nombre="rebatible_2p_negro.webp";    url="Mampara Rebatible de dos paños en color negro-360.webp" }
    @{ nombre="rebatible_perfil_amure.webp";url="Mampara Rebatible con perfil de amure-360.webp" }
    @{ nombre="rebatible_opaco.webp";       url="Mampara Rebatible con puerta en cristal opaco-360.webp" }
    @{ nombre="rebatible_banera_plata.webp";url="Mampara Rebatible para bañera en color plata-360.webp" }
    @{ nombre="rebatible_banera_negro.webp";url="Mampara Rebatible para bañera en color negro-360.webp" }
    @{ nombre="rebatible_negro.webp";       url="Mampara Rebatible color negro-360.webp" }
    @{ nombre="dos_panos_plata.webp";       url="Mampara dos paños con puerta color plata-360.webp" }
    @{ nombre="dos_panos_negro.webp";       url="Mampara dos paños con puerta en color negro-360.webp" }
    # PLEGADIZAS
    @{ nombre="plegadiza.webp";             url="Mampara plegadiza-360.webp" }
    @{ nombre="rebatible_plata.webp";       url="Mampara Rebatible-360.webp" }
)

$ok = 0
$fail = 0

foreach ($img in $imagenes) {
    $dest = "$imgDir\$($img.nombre)"

    # Si ya existe de la corrida anterior, salteamos
    if (Test-Path $dest) {
        $size = (Get-Item $dest).Length
        if ($size -gt 500) {
            Write-Host "  Ya existe: $($img.nombre)" -ForegroundColor Cyan
            $ok++
            continue
        }
    }

    $encodedUrl = $base + (Encode-Url $img.url)

    try {
        Invoke-WebRequest -Uri $encodedUrl -Headers $headers -OutFile $dest -TimeoutSec 15 -ErrorAction Stop
        $size = (Get-Item $dest).Length
        if ($size -gt 500) {
            Write-Host "  OK  $($img.nombre) ($size bytes)" -ForegroundColor Green
            $ok++
        } else {
            Remove-Item $dest -Force
            Write-Host "  --  $($img.nombre) (archivo vacío, no existe en el servidor)" -ForegroundColor Yellow
            $fail++
        }
    } catch {
        if (Test-Path $dest) { Remove-Item $dest -Force }
        Write-Host "  --  $($img.nombre) ($($_.Exception.Message.Split([Environment]::NewLine)[0]))" -ForegroundColor Yellow
        $fail++
    }
}

Write-Host ""
Write-Host "Resultado: $ok fotos descargadas, $fail no encontradas." -ForegroundColor Cyan
Write-Host ""
if ($fail -gt 0) {
    Write-Host "Para las que faltan, podés reemplazarlas con fotos propias o de VIDRIO SRL." -ForegroundColor DarkGray
}
