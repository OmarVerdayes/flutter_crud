#!/bin/bash
# Elimina la carpeta artifacts si ya existe
[[ -d artifacts ]] && rm -r artifacts
# Crea la carpeta artifacts y el subdirectorio web
mkdir -p artifacts/web
# Copia el contenido de build/web a artifacts/web
cp -R build/web/* artifacts/web/
