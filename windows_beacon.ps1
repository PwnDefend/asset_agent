$apikey = ""

$bios = Get-WmiObject -Class Win32_BIOS
foreach($object in $bios){

write-host $object.Manufacturer
write-host $object.SerialNumber
write-host $object.Version

}

$computer = Get-WmiObject -Class Win32_ComputerSystem
foreach($object in $computer){

write-host $object.Manufacturer
write-host $object.Model
write-host $object.DNSHostName
write-host $object.Domain
write-host $object.TotalPhysicalMemory

}

$cpu = Get-WmiObject -Class Win32_Processor
foreach($object in $cpu){
write-host $object.AssetTag
write-host $object.Manufacturer
write-host $object.Name
write-host $object.Architecture

}


$stringAsStream = [System.IO.MemoryStream]::new()

$writer = [System.IO.StreamWriter]::new($stringAsStream)

$writer.write($object.Name + $object.Manufacturer)

$writer.Flush()

$stringAsStream.Position = 0

$guid = (Get-FileHash -Algorithm "SHA256" -InputStream $stringAsStream | Select-Object Hash)

$params = @{"api_token"="$apikey";
"guid"=$guid.Hash.ToString();
}

$beacon = (Invoke-WebRequest -UseBasicParsing "https://beacon.pwndefend.com/api/sniffer" -ContentType "application/json" -Method POST -Body ($params|ConvertTo-Json))
