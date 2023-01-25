Add-Type -AssemblyName  Microsoft.VisualBasic, PresentationCore, PresentationFramework, System.Drawing, System.Windows.Forms, WindowsBase, WindowsFormsIntegration, System;
$Vertexs = @()
[int]$nScreenWidth = 120
[int]$nScreenHeight = 62
[string[]]$screen = @(" " * $nScreenWidth) * $nScreenHeight
$host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size($nScreenWidth, $nScreenHeight)
$host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size($nScreenWidth, $nScreenHeight)
[console]::OutputEncoding = [Text.Encoding]::Ascii
iwr -Uri "https://raw.githubusercontent.com/jh1sc/Powershell-SetFont/main/SetFont.psm1" -OutFile SetFont.psm1;ipmo .\SetFont.psm1
SetFontAsp 0 8 8 48 400 Terminal
function Sphere($radius, $resolution) {
    for ($theta = 0; $theta -lt 2*[Math]::PI; $theta += $resolution) {
        for ($phi = 0; $phi -lt [Math]::PI; $phi += $resolution) {
            $x = $radius * [Math]::Sin($phi) * [Math]::Cos($theta)
            $y = $radius * [Math]::Sin($phi) * [Math]::Sin($theta)
            $z = $radius * [Math]::Cos($phi)
            [System.Windows.Media.Media3D.Point3D]::new($x*10, $y*10, $z*10)
        }
    }
}
$inbw = ($host.UI.RawUI.BufferSize.Width / [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width)
$inbh = ($host.UI.RawUI.BufferSize.Height / [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
$Vertexs = Sphere 2 0.19
$ShadeIndex = "MQW#BNqpHERmKdgAGbX8@SDOPUkwZyF69heT0a&xV%Cs4fY52Lonz3ucJjvItr}{li?1][7<>=)(+*|!/\;:-,_~^.'"
$lightIntensity = 0.7
$sw = [Diagnostics.Stopwatch]::New()
$theta = 0.008
$cosTheta = [System.Math]::Cos($theta);$sinTheta = [System.Math]::Sin($theta)
while ($true) {
    $sw.Restart()
    $screen = @(" " * $nScreenWidth) * $nScreenHeight
    $iter += 0.3;$distance = 45 + (20 * [Math]::Sin(($iter / 180) * [Math]::PI))
    $mx = [int]([System.Windows.Forms.Cursor]::Position.x * $inbw)
    $my = [int]([System.Windows.Forms.Cursor]::Position.y * $inbh)
    $lightPosition = [pscustomobject]@{x=$mx;y=$my;z=0}
    for ($j=0; $j -lt $Vertexs.Length; $j++) {
        $x = $Vertexs[$j].x
        $z = $Vertexs[$j].z
        $Vertexs[$j].x = $x * $cosTheta - $z * $sinTheta
        $Vertexs[$j].z = $z * $cosTheta + $x * $sinTheta
        $y = $Vertexs[$j].y
        $z = $Vertexs[$j].z
        $Vertexs[$j].y = $y * $cosTheta - $z * $sinTheta
        $Vertexs[$j].z = $y * $sinTheta + $z * $cosTheta
        $x = $Vertexs[$j].x
        $y = $Vertexs[$j].y
        $Vertexs[$j].x = $x * $cosTheta + $y * $sinTheta
        $Vertexs[$j].y = $y * $cosTheta - $x * $sinTheta
        $lightVector = [math]::Sqrt((($lightPosition.X-$Vertexs[$j].x)*($lightPosition.X-$Vertexs[$j].x))+ (($lightPosition.Y-$Vertexs[$j].y)*($lightPosition.Y-$Vertexs[$j].y)) + (($lightPosition.Z-$Vertexs[$j].z)*($lightPosition.Z-$Vertexs[$j].z)))
        $objectNormal = [math]::Sqrt((($Vertexs[$j].x)*($Vertexs[$j].x))+ (($Vertexs[$j].y)*($Vertexs[$j].y)) + (($Vertexs[$j].z)*($Vertexs[$j].z)))
        $cosAngle = ($lightVector*$lightVector + $objectNormal*$objectNormal - $lightVector*$objectNormal)/(2*$lightVector*$objectNormal)
        $shading = [Math]::Max(0, [Math]::Min(([Math]::Round(($cosAngle / $lightIntensity) * ($ShadeIndex.Length - 1))), $ShadeIndex.Length - 1))
        [char]$shade = $ShadeIndex[$shading]
        $normalizingFactor = $distance / ($distance + $z)
        $x = [math]::round(($x * $normalizingFactor) + $nScreenWidth/2)
        $y = [math]::round(($y * $normalizingFactor) + $nScreenHeight/2)
        try {$screen[$y] = $screen[$y].Remove($x, 1);$screen[$y] = $screen[$y].Insert($x, $shade)}catch{}
    }
    $sw.Stop()
    $fps = [math]::Round(10000000/$sw.ElapsedTicks)
    [system.console]::title = "Made by: Jh1sc - FPS: $fps"
    [console]::setcursorposition(0,0)
    [console]::write([string]::Join("`n", $screen))
}
