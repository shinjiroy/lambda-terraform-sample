#!/bin/bash

# デプロイ用シェル

set -e

# 引数の数をチェック
if [ $# -ne 1 ]; then
    echo "引数が必要です。 development か production を指定してください。"
    exit 1
fi

ENVIRONMENT_ARG=$1
# 引数が production であるかをチェック
if [ "$ENVIRONMENT_ARG" != "production" ] && [ "$ENVIRONMENT_ARG" != "development" ]; then
    echo "引数は development か production を指定してください。"
    exit 1
fi

# productionに限り、mainブランチでのみのデプロイを許可する
if [ "$ENVIRONMENT_ARG" = "production" ]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$CURRENT_BRANCH" != "main" ]; then
        echo "productionをデプロイするならmainブランチでデプロイしてください。"
        exit 1
    fi
fi

# コンテナイメージを最新化
# TODO DockerHub側のRate Limitに引っかかる可能性が無きにしも非ずなので非常に迷う
# docker-compose pull

# dist_lambdaに移動しつつ、pip install
docker compose run --rm builder

docker compose run --rm terraform bash -c "cd ./$ENVIRONMENT_ARG && terragrunt run-all plan"

# run-all init要らないっぽい
docker compose run --rm terraform bash -c "cd ./$ENVIRONMENT_ARG && terragrunt run-all apply"
