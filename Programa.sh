#!/bin/bash

#"Programa que monitorea los procesos del usuario en un determinado tiempo"

#//////////////////////////validaciones///////////////////////////////////////

if [ ! -f /var/log/syslog ]; then                                              
    echo "no existe el archivo syslog"
    exit                                                                       
fi

if [ ! -x /usr/bin/logger ]; then                                              
    echo "no se tienen los respetivos permisos del comando logger"             
    exit                                                                       
fi  

if [ ! -x /usr/bin/top ]; then
    echo "error con el comando top"
    echo "verifique que contiene dicho comando y que cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando top"
    exit
fi

if [ ! -x /bin/ps ]; then
    echo "error con el comando ps"
    echo "verifique que contiene dicho comando y que cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando ps"
    exit
fi 

if [ ! -x /bin/grep ]; then
    echo "error con el comando"
    echo "verifique que contiene dicho comando y que cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando grep"
    exit
fi

if [ ! -x /usr/bin/cut  ]; then
    echo "error con el comando cut"
    echo "verifique que contiene dicho comando y que cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando cut"
    exit
fi

if [ ! -x /usr/bin/sort ]; then
    echo "error con el comando sort"
    echo "verifique que contiene dicho comando y que cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando sort"
    exit
fi

if [ ! -x /usr/bin/uniq ]; then
    echo "error con el comando uniq"
    echo "verifique que contiene dicho comando y que cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando uniq"
    exit
fi

if [ ! -x /usr/bin/head ]; then
    echo "error con el comando head"
    echo "verifique que contiene dicho comando y que se cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando head"
    exit
fi 

if [ ! -x /bin/sed  ]; then
    echo "error con el comando sed"
    echo "verifique que contiene dicho comando y que se cuenta con permisos de ejecucion"
    logger "Error del script Programa.sh error con el comando sed"
    exit
fi

if [ ! -w /var ]; then
    echo "error al escribir archivos en el directorio var"
    echo "verifique los permisos del directorio"
    logger "Error del script Programa.sh error con el directorio var"
    exit
fi

if [ ! -r /etc ]; then
    echo "error al leer archivos del directorio etc"
    echo "verifique los permisos del directorio"
    logger "Error del script Programa.sh error con el directorio etc"
    exit
fi

if [ ! -f /etc/archivoConfiguracion.txt ]; then
    echo "error al leer archivoCofiguracion"
    echo "verifique que exista el archivo en en directorio /etc"
    logger "Error del script Programa.sh error con el archivoConfiguracion"
    exit
fi

if [ ! -r /etc/archivoConfiguracion.txt ]; then
    echo "error al leer archivoConfiguracion"
    echo "verifi que tiene los respectivos permisos del archivo"
    logger "Error del script Programa.sh error con el archivoConfiguracion"
    exit
fi

#//////////////////////funciones///////////////////////////////////////////
 usuario=$USER
 
 #funcion imprimir normal
 function imprimirDatos() {
     echo "El usuario es : "$usuario | tee -a /var/salidaDatos.txt    
     echo "El total de procesos es : " | tee -a /var/salidaDatos.txt
     top -n1 -b -u $usuario | grep -c $usuario | tee -a /var/salidaDatos.txt
     echo "El estado de los procesos es :" | tee -a /var/salidaDatos.txt
     ps -lu $usuario | cut -c3 | sort | uniq -c | tee -a /var/salidaDatos.txt
     echo "El proceso que mas memoria esta consumiendo es :"|tee -a /var/salidaDatos.txt
     ps -u $usuario aux --width 30 --sort -rss | head -n2|tee -a /var/salidaDatos.txt
  } 

rojo='\e[1;31m'
azul='\e[1;34m' 
marron='\e[0;33m' 
verde='\e[0;32m'
cyan='\e[0;36m'  
 
 #funcion imprimir conformato
 function imprimirDatosFormato() {
     echo -e "${rojo}------------------------imprimiendo con formato---------------------------------"|tee -a /var/salidaDatos.txt;
echo -e "${verde} El usuario :"|tee -a /var/salidaDatos.txt;
echo -e "${verde} $usuario"|tee -a /var/salidaDatos.txt
echo "--------------------------------------------------------------------------------"|tee -a /var/salidaDatos.txt;
echo -e "${marron} El total de procesos es : "|tee -a /var/salidaDatos.txt
echo -e "${marron} $var"|tee -a /var/salidaDatos.txt
echo "--------------------------------------------------------------------------------"|tee -a /var/salidaDatos.txt;
echo -e "${azul} El estado de los procesos es :"|tee -a /var/salidaDatos.txt
echo -e "${azul} $varProce"|tee -a /var/salidaDatos.txt
echo "--------------------------------------------------------------------------------"|tee -a /var/salidaDatos.txt;
echo -e "${cyan} El proceso que mas memoria esta consumiendo es :"|tee -a /var/salidaDatos.txt 
echo -e "${cyan} $varMasMemoria"|tee -a /var/salidaDatos.txt
echo -e "${rojo}--------------------------------------------------------------------------------"|tee -a /var/salidaDatos.txt;
     
 }

#////////////////////////variables configurables del archivo de etc//////////// 
#usuario=$(sed -n '9p' /etc/archivoConfiguracion.txt| sed -e 's/usuario=//')     
tiempo=$(sed -n '11p' /etc/archivoConfiguracion.txt| sed -e 's/tiempo=//')      
formato=$(sed -n '13p' /etc/archivoConfiguracion.txt| sed -e 's/formato=//')   

#//////////////////////variables/////////////////////////////////////////
var=$(top -n1 -b -u $usuario | grep -c $usuario)                                                                                                                       
varProce=$(ps -lu $usuario | cut -c3 | sort | uniq -c)                                                                                                                 
varMasMemoria=$(ps -u $usuario aux --width 30 --sort -rss | head -n2) 
varContador=0

#////////////////////////validacion del getopts//////////////////////////////
while getopts " :u:ft:h " variable; do                                                                                                                      
case $variable in                                                                                                                                           
   u)                                                 
       usuario=$OPTARG;;                                                                                                                                                                                                                                   
   f)
       formato=1;;
   t)
       tiempo=$OPTARG;;

   h)
      #############################################################
echo "Modo de empleo: ./Programa.sh [OPCIÓN]..."
echo "Monitorea los procesos en ejecucion por usuario,"
echo "durante un lapso de tiempo determinado."
echo " "
echo "  -u,                      indica de que usuario se monitorearan los procesos" 
echo "  -t,                      tiempo de monitoreo" 
echo "  -f,	                   formato personalizado de salida de datos"
echo "  -h,                      muestra esta ayuda y finaliza"
echo " "
echo "Ejemplos:"
echo " "
echo "   ./Programa.sh -f -u Asterion  Monitorea los procesos del usuario Asterion,e"
echo "                                 imprime con formato personalizado"
echo " "
echo "   ./Prograna.sh -t 2            Monitorea durante 2 minutos los procesos del" 
echo "                                 usuario por defecto"
echo " "
echo "Comunicar errores de este script a 00500411@uca.edu.sv"        
      exit;;
   
   \?)
       echo "opcion no valida" 
       exit;; 
esac                                                                           
done

#///////////////////////validaciones de las variables////////////////////////
if  ! grep  -qi $usuario /etc/passwd 
 then
    echo "el usuario no existe"
    logger "error en el script Programa error : usuario no existente"
    exit
fi            


if [ $tiempo -gt 5 ]; then
    echo "el tiempo es muy grande "
    logger "error en el script Programa error : tiempo fuera de rango"
    exit
fi

if [ $tiempo -lt 0 ]; then
    echo "el tiempo no es valido"
    logger "error en el script Programa error : tiempo fuera de rango"
    exit
fi
#///////////////////////ejecucion////////////////////////////////////////////
 echo "-----------------------AL INICIO DEL PROGRAMA----------------------------------- "|tee -a /var/salidaDatos.txt
if [ $formato -eq 1 ]; then
    imprimirDatosFormato 
else
    imprimirDatos
fi

#asi se puede usar este comando de tiempo
while [ $((60*tiempo)) -gt $varContador ]; do #aca contando el tiempo por defecto 60 seg

    sleep 1
    varContador=$((varContador+1))
    #echo $varContador 
done

echo "-----------------------AL FINAL DEL PROGRAMA------------------------------------"|tee -a /var/salidaDatos.txt

if [ $formato -eq 1 ]; then                                                                                                                                
    imprimirDatosFormato             
else                                                                                                                                                             imprimirDatos                                                          
fi 
