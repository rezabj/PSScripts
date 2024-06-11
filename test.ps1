$p = 1..358

$Batch = 0
$BatchSize = 10

do {
    $Processing = [System.Collections.Generic.List[Object]]::new()
    for ($i = $Batch; (($i -lt ($Batch + $BatchSize)) -and ($i -lt $p.Count)); $i++) {
        $Processing.Add($p[$i])
    }
    $Processing | ForEach-Object -Parallel {
        Write-Output $_
    } -ThrottleLimit 5
    [System.GC]::Collect()
    Write-Host "Batch: $Batch to $i"
    $Batch += $BatchSize
} while ($Batch -lt $p.Count)