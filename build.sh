#!/bin/bash

set -e

echo "Instalando Flutter..."

git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:`pwd`/flutter/bin"

flutter --version

echo "Instalando dependências..."

flutter pub get

echo "Gerando Flutter Web..."

flutter build web --release

echo "Build finalizado"