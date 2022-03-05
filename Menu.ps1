$MyInvocation.ScriptName
$script:pathgroup = @()

function main (){
    $CommandLog = "<logfile_path>";
    $sakuraexe = "<sakura.exe_path>";
    $winScpexe = "<winScpexe.exe_path>";

    $appli = "<application_folder_path>"

    do {
        $commandorg = "";
        while ($commandorg -eq "") {
            $commandorg = (Read-Host).trim().trim("[]")
        }
        (Get-Date).toString("yyyy/MM/DD HH:mm:ss: ")+$commandorg | Add-Content $CommandLog;
        $command = $commandorg;

        $command = $command.split(" ");
        switch($command[0]){
            "p" {$command[0] = "powershell"}
            "l" {$command[0] = "teggol"    }
            "s" {$command[0] = "set"       }
            default {  }
        }

        if($command[0] -eq "jsv" -and $null -ne (Get-Process | Where-Object{$_.Name -eq "JSV_HOUDAI"} | ForEach-Object{$_.CloseMainWindow()})){
            continue;
        }

        switch($command[0]){
            $([char]4)   { exit }
            "clog"       {  Start-Process $sakuraexe $CommandLog}
            "t"          {  Start-Process sakuraexe "<temp_path>"}
            "teggol"     {  Get-Clipboard -Format FileDropList | %{&"${appli}/TEGGOL.ps1" "$_"}}
            "list"       {  Show-List }
            "powershell" {  powershell}
            "set"        {  Set-Group $command[1] }
            "cpdf"       {  Get-Process FoxitReader | %{$_.CloseMainWindow()} > $null }
            ""           {  }
            "gsk"        { Get-Process sakura | Stop-Process}
            "update"     { Update-List }

            default {
                try{   Start-Path $command }
                catch{ "?"; }
            }
        }
    }while ($true)
}

function Read-List() {
    process{
        $lastgroup = ""
        $lastname  = ""
        $pathdir   = ""

        Write-Output "Read-List $_"

        $csv = ls $pathdir "*$_*" | Select-Object -first 1 | cat | ConvertFrom-Csv -Delimiter "`t"

        $csv | Add-Member -MemberType NoteProperty -Name FullPath -Value "" -Force
        $csv |
        ForEach-Object {
            #Name未指定は一つ上と同じ
            if( $_.Name -ne "") {$lastname = $_.Name }
            else{               $_.Name    = $lastname }

            #basegroup未指定はgroup
            $source.Add($_) > $null
        }
    }
}

function Update-List(){
    $script:source = New-Object System.Collections.ArrayList
    "Main" | Read-List
}

function Start-Path($ky){
    $count=0
    $key = @($ky)
    $old = $null

    if ($key.length -gt 1){
        $old = $pathgroup[0]
        Set-Group $key[0]
        $key = @($key[1])
    }

    $source |
    Where-Object{
        $pathgroup -contains ($_.group) -and [bool]($_.Name -split "," -eq $key[0])
    } |
    ForEach-Object {
        $count += 1
        $item = $_


    }
}

function Set-Group (){

}

function Show-List {


}

$script:source = ""

Update-List
$source | Format-Table
Set-Group nsv
Clear-Host
main