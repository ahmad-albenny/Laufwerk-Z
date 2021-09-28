#check the wireless adapter
$array =netsh wlan show interfaces
#with z we extracte only info about z 
$laufwerkZ=Get-PSDrive Z
#networks ID
$ssiDs="PHORMS","PhormsSchool","PhormsEducation"

#to check, if the device is in phorms network
function inSidePhorms{
$inSide=$false
$i=0
while ($i -lt $ssiDs.length){
   #check the ssid 
   if($array[8].Contains($ssiDs[$i])){
   $inSide=$true
   }
   $i++   
}
   return $inSide
}

#the user have to write his name to find the directory
function check_HomeDirectory{
$user=-Split (query user)
$username=$user[6].split(">")
$userInfo= net user /domain $username
$directory= -Split $userInfo[19] 
return $directory[1]# HomeDirectory
}

#to check, if the Z is connected
function isZZ{
$isZ=$false
$userDirectory= check_HomeDirectory
   if ($laufwerkZ.Name -eq "Z" -and 
       $laufwerkZ.DisplayRoot -eq $userDirectory){
       $isZ=$true
       }
return $isZ
}

#main function to check the connection and install Z, if it tear down
function makeConnection{
$userDirectory= check_HomeDirectory 
if(inSidePhorms -and isZZ ){
    Write-Host "Alles OK" 
}elseif(-not (inSidePhorms) ) {
    Write-Host "Sie Sind nicht in einem der Phorms Netzwerke"
}elseif(-not (isZZ)) {
    Write-Host "Z wird Verbunden werden"
    New-PSDrive -Name Z -Root $userDirectory -Persist -PSProvider FileSystem
}
}


makeConnection
