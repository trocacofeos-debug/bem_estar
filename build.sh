#!/bin/bash

set -e

echo "=== Instalando Flutter ==="

git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter

export PATH="$PATH:$(pwd)/flutter/bin"

echo "=== Versão Flutter ==="

flutter --version


echo "=== Habilitando Web ==="

flutter config --enable-web


echo "=== Dependências ==="

flutter pub get


echo "=== Build Web ==="

flutter build web --release --no-tree-shake-icons


echo "=== Finalizado ==="