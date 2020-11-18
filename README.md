perutil-script-linux
=========

**SCRIPT BASH SHELL** : Commandi più usati per verificare il stato del Web Application JBOSS / EAP.

[![Build Status](https://travis-ci.org/ekalinin/github-markdown-toc.svg?branch=master)](https://travis-ci.org/ekalinin/github-markdown-toc)

Installazione
============

Linux 
```bash
$ wget https://github.com/peruvianit/perutil-script-linux/blob/main/perutil
$ chmod a+x perutil
```
Aprire il file e configurare la variabile **WEB_SERVERS=** e aggiornare la lista di web application server, con  la coppia <NOME_WEB_APP_SERVER>**|**<PATH_WEB_APP_SERVER> e per aggiungere altri dare un **spazio**
Esempio
```bash
WEB_SERVERS=EAP-6.4|/opt/Jboos-eap-6.4 EAP-7.1|/opt/Jboos-eap-7.1
```

Utilizzo
=====

```bash
➥ ./perutil

----------------------------------------
PERUTIL - Helper (JBoos/EAP)
----------------------------------------
1. Memoria disponibile
2. Espazio in Disco
3. Applicazioni Deployate
4. Applicazione Failed
5. JNDI Datasources
6. Log configurati
7. Errori server.log ultime 2 ore
8. Restart Servizio
9. Info
10. Esci
```
