Add-Type -AssemblyName System.Drawing
$dir = $PSScriptRoot
$src = Join-Path $dir '1780441905134.png'
if (-not (Test-Path $src)) { $src = Join-Path $dir 'phonix.png' }
$img = [System.Drawing.Image]::FromFile($src)

function Save-Icon([int]$size, [string]$name, [double]$scale) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.Clear([System.Drawing.Color]::FromArgb(255, 0, 26, 51))
  $pad = [int]($size * (1 - $scale) / 2)
  $max = $size - 2 * $pad
  $ratio = [Math]::Min($max / $img.Width, $max / $img.Height)
  $w = [int]($img.Width * $ratio)
  $h = [int]($img.Height * $ratio)
  $x = [int](($size - $w) / 2)
  $y = [int](($size - $h) / 2)
  $g.DrawImage($img, $x, $y, $w, $h)
  $g.Dispose()
  $path = Join-Path $dir $name
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host "OK $name"
}

Save-Icon 192 'icon-192.png' 0.88
Save-Icon 512 'icon-512.png' 0.88
Save-Icon 512 'icon-maskable-512.png' 0.72
$img.Dispose()
