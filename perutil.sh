# ! /bin/bash
#=====================================================================================
#
# File        : utiliti.sh
# Utilizzo    : ./utiliti.sh
#
# Descrizione : Utiliti per la verfica inf del sistema e deployment applicazione
#
# Autore      : Sergio Arellano Diaz
# Versione    : 1.0
# Creato      : 14/11/2020 12:00
# Revisioni   :
#======================================================================================

#======================================================================================
# WEB_SERVERS = <NOME_WEB_APP_SERVER>|<PATH_WEB_APP_SERVER>|<NOME_SERVIZIO> 
#               Per aggiungere altri aggiungere un spazio e aggiungere il nuovo server.
#======================================================================================

WEB_SERVERS="HOME|/home/sarellano|SERVIZIO OPT-LINUX|/opt|SERVIZIO ETC-LINUX|/etc|SERVIZIO"

#======================================================================================
# COLORS SETTING
#======================================================================================

BROWN_ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#======================================================================================
# INFORMAZIONE DEL SCRIPT
#======================================================================================
function aiuto {
    cat <<AIUTO_PER
    Autore     : Sergio Arellano Diaz ( sergioarellanodiaz@gmail.com )
    Repository : https://github.com/peruvianit/perutil-script-linux.sh
    Version    : 1.0.0

    commando ./perutil

AIUTO_PER
}


#======================================================================================
# Pausa dopo un comando
#======================================================================================
function pausa {
    echo -e "\n"
    read -sp "Presiona Invio per continuare..."
}


#======================================================================================
# server_selezionato = Dopo la scelta è salvato per effettuare l'azione
#======================================================================================

server_selezionato=0
servizio_server_selezionato=0

function selezione_web_server(){
    opzione_server=0
    numero_server=0

    echo "Web server :"

    for web_server in $WEB_SERVERS
    do
        numero_server=$((numero_server+1))
#        echo "$numero_server) $web_sierver"
        nome_server=$( echo $web_server |  awk '{split($0,a,"|"); print a[1]}' )
        echo "$numero_server) $nome_server"
    done

    echo -e "\n"
    # Catturare dati dal utente
    read -n1 -p "Scegliere una opzione [1-$numero_server] : " opzione_server
    echo -e "\n"

    # Seleziona Web Server

    arr=($WEB_SERVERS)
    info_server=${arr[opzione_server-1]}

    #echo -e "################################################################"
    #echo -e "Server selezionato : $( echo $info_server | awk '{split($0,a,\"|\"); print a[1]} )"
    #echo -e "################################################################\n"

    nome_server_selezionato=$( echo $info_server |  awk '{split($0,a,"|"); print a[1]}' )
    server_selezionato=$( echo $info_server |  awk '{split($0,a,"|"); print a[2]}' )
    servizio_server_selezionato=$( echo $info_server |  awk '{split($0,a,"|"); print a[3]}' )

    echo -e "################################################################"
    echo -e "Server selezionato : $nome_server_selezionato                     "
    echo -e "################################################################\n"

}

opzione=0

while :
do
    # Pulisci schermo
    clear
    # Creazione Menu
    echo "-----------------------------------------"
    echo "PERUTIL - Helper (JBoos/EAP)             "
    # >>>info stato server
    printf "\n${BROWN_ORANGE}Memoria disponibile [$( grep MemFree /proc/meminfo | awk '{print $2 / 1024}' )] (Megabytes)${NC}\n"
    # <<< info stato server
    echo "-----------------------------------------"
    echo "1. Memoria disponibile"
    echo "2. Spazio in Disco"
    echo "3. Applicazioni Deployate"
    echo "4. Applicazione Failed"
    echo "5. JNDI Datasources"
    echo "6. Log configurati"
    echo "7. Errori server.log ultime 2 ore"
    echo "8. Restart Servizio"
    echo "9. Info"
    echo "10. Esci"

    echo -e "\n"

    # Catturare dati dal utente
    read -n2 -p "Scegliere una opzione [1-10] : " opzione
    echo -e "\n"
    # verificare opzione
    case $opzione in
        1)
            free -m
            pausa
            ;;
        2)
            df -h
            pausa
            ;;
        3)
            selezione_web_server
            echo ">> Applicazioni trovate : [$( find $server_selezionato -type f -name *deployed | wc -l )]"
            find $server_selezionato -type f -name *deployed -exec ls -l {} \;
            pausa
            ;;
        4)
            selezione_web_server
            echo ">> Applicazioni trovate : [$( find $server_selezionato -type f -name '*failed' | wc -l )]"
            find $server_selezionato -type f -name "*failed" -exec ls -l {} \;
            pausa
            ;;
        5)
            selezione_web_server
            path_file=$server_selezionato/standalone.xml
            if [ -f "$path_file" ]; then 
                echo ">> Jndi trovati : [$( egrep -Eo 'jndi-name.\"java.([[:alnum:]]|/)+{,2}\"' $path_file | wc -l )]"
                egrep -Eo 'jndi-name."java.([[:alnum:]]|/)+{,2}"' $path_file
            else
                echo "Il file $path_file non esiste, controllare se è un web application server!"
            fi
            pausa
            ;;
        6)
            selezione_web_server
            path_file=$server_selezionato/standalone.xml
            if [ -f "$path_file" ]; then
                echo ">> Log trovati : [$( egrep -Eo 'relative.*' $path_file | egrep -o 'path.*(\"){1,2}' | wc -l )]"
                egrep -Eo 'relative.*' $path_file | egrep -o 'path.*("){1,2}'
            else
                echo "Il file $path_file non esiste, controllare se è un web application server!"
            fi
            pausa
            ;;
        7)  
            selezione_web_server
            path_file=$server_selezionato/server.log
            if [ -f "$path_file" ]; then
                grep "^$( date --date="-2 hours" +"%H" ).*ERROR.*$" $path_file
                echo -e  "\n>>  Errori trovati : [$( grep ^$( date --date='-2 hours' +'%H' ).*ERROR.*$ $path_file | wc -l )]"
            else
                echo "Il file $path_file non esiste, controllare se è un web application server!"
            fi
            pausa
            ;;
            
        8)  
            selezione_web_server
            sudo service $servizio_server_selezionato stop
            sudo service $servizio_server_selezionato start
            pausa
            ;;
        9)
            aiuto
            pausa
            ;;
        10) 
            echo -e "\n"
            exit 0
            ;;
        *)  
            echo -e "La opzione selezzionata non è valita!"    
            pausa
            ;;
    esac
done
