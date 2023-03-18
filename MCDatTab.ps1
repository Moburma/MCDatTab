#Magic Carpet DAT/TAB Creator by Moburma

#VERSION 1.0
#LAST MODIFIED: 18/03/2023

<#
.SYNOPSIS
   This script can concatenate Magic Carpet LEV000XX.DAT level files into the needed LEVELS.DAT and LEVELS.TAB files to run them in game. 
   This is necessary if you want to edit, re-order, or add more levels to the game in order to actually play them.

.DESCRIPTION    
    This script has no parameters, just run it in a directory with ALL the .DAT files from the LEVELS directory of the ORIGINAL game release
    CD (NOT Magic Carpet Plus).
    Note: It does NOT create .DAT/TAB files in the format used by graphics in Bullfrog games!
        

.RELATED LINKS
    
    Magic Carpet level file format: https://github.com/michaelhoward/MagicCarpetFileFormat/blob/master/magic%20carpet%20file%20format.txt
    
#>

#Error handling, check if the first level file is present
if ((Test-Path -Path "LEV00000.DAT" -PathType Leaf) -eq 0){
write-host "Error - LEV00000.DAT not found. You must run this script from a directory with all game LEV000XX.DAT files present!" -ForegroundColor Red
write-host ""
exit
}

#Define Header for DAT file

[byte[]] $datoutput = 0x42, 0x55, 0x4C, 0x4C, 0x46, 0x52, 0x4F, 0x47   #BULLFROG

$levelcount = 0

function write-progresshelper  {
Write-Progress -Activity "Concatenating level file $levfile" -Status "Adding level $levelcount / 1000" -PercentComplete ( ($levelcount/1000) * 100)

}


DO{   # Script is hardcoded to only add 70 level files as per the retail game. Feel free to change the limit on this loop and the next one if you want to add more levels


if ($levelcount -lt 10){

    $levfile = "LEV0000"+"$Levelcount"+".DAT"
    }
Else{
    $levfile = "LEV000"+"$Levelcount"+".DAT"
    }

write-progresshelper 

if ($levelcount -eq 0){      #BULLFROG header means first entry is always byte 08
    [byte[]] $taboutput = 0x08, 0x00, 0x00, 0x00
    }
Else {
    $taboutput = @($taboutput  + $endlength) -as [byte[]]

}

#write-host "Adding level file $levfile"

    $readlevel = get-content $levfile -Encoding Byte -ReadCount 0
    $datoutput = @($datoutput + $readlevel) -as [byte[]]


#write-host $levelcount

$endlength = [System.BitConverter]::GetBytes($datoutput.Length)


$levelcount = $levelcount + 1


}UNTIL ($levelcount -eq 70)


Set-Content LEVELS.DAT -Value $datoutput -Encoding Byte


DO{
$taboutput = @($taboutput  + $endlength) -as [byte[]]
$levelcount = $levelcount + 1
#write-host $levelcount
write-progresshelper 
}UNTIL ($levelcount -eq 1000)

Set-Content LEVELS.TAB -Value $taboutput -Encoding Byte