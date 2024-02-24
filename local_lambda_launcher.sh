#!/bin/bash

# ローカルでLambdaをテスト実行する
# ※docker-composeでやりたかったけど、ビルド対象を切り替えるのがムズそうだったので
#   docker buildしつつ、起動はdocker-composeに任せる感じにしてます。毎回ビルド走りますけど許してください。

# 使い方 ./local_lambda_launcher.sh {/lambda以下のテスト対象のディレクトリ名}
# 例: ./local_lambda_launcher.sh sample

set -e

# 引数チェック
TARGET_LAMBDA_NAME=$1
if [ -z $TARGET_LAMBDA_NAME ]; then
    echo "Usage: ./local_lambda_launcher.sh {/lambda以下のテスト対象のディレクトリ名}"
    exit 1
fi

# .envの値を実行時に環境変数として展開する
set -a
source .env
set +a

# テスト対象Lambda用のコンテナイメージをビルド
# Note: タグにlatestじゃなくて、$TARGET_LAMBDA_NAMEをいれて、Lambda毎にイメージを作成するのもアリだけど、Lambdaが増えると大量のイメージが出来て容量圧迫しそう。
IMAGE_TAG=$COMPOSE_PROJECT_NAME-lambda:latest
docker build . -t $IMAGE_TAG -f ./local/lambda/Dockerfile \
    --build-arg TARGET_LAMBDA_NAME=$TARGET_LAMBDA_NAME

# docker-compose.yamlの設定を使ってコンテナ起動
docker compose up -d lambda
# Noneのやつがいっぱいできないようにこまめに掃除
docker image prune -f

echo "コンテナ起動後はこんな感じで実行！-dの内容は適宜変える事"
echo "curl "http://localhost:$LAMBDA_PORT/2015-03-31/functions/function/invocations" -d '{}'"
