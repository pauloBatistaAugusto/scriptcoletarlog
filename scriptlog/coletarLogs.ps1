#Autor: Paulo Augusto Batista
#Atualização: 15/01/2021
#Objetivo do Script: Coletar log

try
{

 #Preencher------------------------------------------------------------------------------
 $Logfile = "C:\scriptlog\log\log.log"
 $diretoriosComArquivosParaEnvio = "C:\scriptlog\log\dir.txt"
 #Exemplo: "2021/01/14/10/00/00"
 $dataHoraSolicitadoParaColetaInicial = "2021/01/13/00/00/00"
 $dataHoraSolicitadoParaColetaFinal = "2021/01/13/23/59/00"
 #---------------------------------------------------------------------------------------
 
 $diretorioAtual
 $diretorioDestino


 Function LogWrite
 {
    Param ([string]$logstring)
	
    $dataLog = Get-Date
    $dataLog = ($dataLog.toString("dd-MM-yyyy HH:mm:ss"))
    
    Add-content $Logfile -value  ("[" + $dataLog + "] - " + $logstring)
    
    #Se maior que 1MB apaga
    $arquivoLog = Get-Item $Logfile
    if($arquivoLog.length -gt 1mb)
     {
      $arquivoLog.Delete()
     }
 }
 
 #Percorre o arquivo txt com os diretorios parametrizados
  Get-Content $diretoriosComArquivosParaEnvio | Where-Object {$_ -match $regex} | ForEach-Object{
  
    
    $diretorioAtual, $diretorioDestino = $_.split(',')

    
    If(!(test-path $diretorioDestino))

      {
        New-Item -ItemType Directory -Force -Path $diretorioDestino
      }
     
    LogWrite ("Diretório atual: " + $diretorioAtual)
    $filelist = Get-ChildItem -Path $diretorioAtual -Filter * -Recurse 
 
     foreach($item in $filelist)
     {
           
      $dateDataAtual = Get-Date
      $dateDataDesejadaInicial = [datetime]::ParseExact($dataHoraSolicitadoParaColetaInicial,"yyyy/MM/dd/HH/mm/ss",$null)
      $dateDataDesejadaFinal = [datetime]::ParseExact($dataHoraSolicitadoParaColetaFinal,"yyyy/MM/dd/HH/mm/ss",$null)
      $dateDataUltimaEscritaNoArquivo = $item.LastWriteTime
       
      if($item.length -gt 0)
      {
      
            
       if($dateDataUltimaEscritaNoArquivo -igt  $dateDataDesejadaInicial -and $dateDataUltimaEscritaNoArquivo -lt $dateDataDesejadaFinal)
        {
       
         LogWrite ("Copiando arquivo: " + $item.fullname + " para: ->" + $diretorioDestino)
         Copy-Item $item.fullname  -Destination $diretorioDestino -Recurse
   
        }   
      }
     }
    }
 }
catch
{
  LogWrite $_.Exception.Message.toString(); 
}