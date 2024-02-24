#!/bin/bash

# builderコンテナのentrypoint

set -e

# 一旦dist_lambdaディレクトリの中身を空にする
rm -rf dist_lambda/*

# lambdaディレクトリ直下のディレクトリそれぞれでpip installする
for dir in ./lambda/*/; do
    if [[ -d "$dir" ]]; then
        dir_name=$(basename "$dir")
        echo "${dir_name}の分をpip install"
        # dist_lambda以下にディレクトリを丸ごとコピーする
        cp -r "$dir" dist_lambda/

        # pip install
        cd dist_lambda/"$dir_name"
        pip install -r requirements.txt --target .
        cd ../../
    fi
done
