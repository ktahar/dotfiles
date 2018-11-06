#!/bin/bash

cd ~/eijiro-utf8
nkf EIJI-144.TXT | cut -c 4- > eiji144-utf8.txt
nkf REIJI144.TXT | cut -c 4- > reiji144-utf8.txt
nkf RYAKU144.TXT | cut -c 4- > ryaku144-utf8.txt
nkf WAEI-144.TXT | cut -c 4- > waei144-utf8.txt

chmod -w eiji144-utf8.txt reiji144-utf8.txt ryaku144-utf8.txt waei144-utf8.txt
