#!/bin/bash

wgetHeader='User-Agent: Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11'
URLpdfP1='https://link.springer.com/'
pdfNAMEsearch="<div data-test="book-title" class="page-title">
<h1>"
NUM=1
extFile=.pdf

while IFS= read -r enlace; 
  do 
    clear;
    rm -rf WEBPAGE
    # espera aleatorio en rango de 60s, el objetivo es que no bloqueen las descargas x abuso 
    DELAY=$(( RANDOM % 60 )); 
    while [ $DELAY -gt 0 ];
      do clear;
        echo Esperando [$DELAY]; 
        sleep 1s; 
        DELAY=$(( $DELAY - 1 )); 
    done
    echo Descarga [$NUM];
    echo Abriendo [$enlace];
    wget -q --header="$wgetHeader" -O WEBPAGE $enlace;
    pdfNAME=$(cat WEBPAGE | grep "$pdfNAMEsearch" | sed 's/<h1>/ /g' | sed 's/<\/h1>/ /g' | sed -e 's/^[ \t]*//' | sed 's/ *$//')$extFile;
    echo "Título Libro:" $pdfNAME;
    URLpdfP2=$(cat WEBPAGE | grep '<a href="/content/pdf/' | head -n 1 | tr -d ' ' | cut -d'"' -f 2);
    echo URL descarga [$URLpdfP2];
    wget -c --header="$wgetHeader" $URLpdfP1$URLpdfP2 -O "$pdfNAME"; 
    NUM=$(( $NUM + 1 )); 
    sleep 3s;
done < libros
