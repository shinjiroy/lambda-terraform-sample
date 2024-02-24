# lambda-terraform-sample

## これはなに

Terraformで複数のLambdaのコードも一緒に管理する場合のサンプルです。

AWS Lambdaを使ったシステムを開発してデプロイするならばServerlessとかAWS SAMとかを使うかもしれませんが、大人の事情によりTerraformで管理したいとなる時もあると思います。(Lambda@Edge用Lambdaを開発する時とか)  
その時にローカル環境として出来て欲しい以下のことを実現する構成のサンプルです。

- Serverlessとかのように、Lambdaとしてローカルで動かしたい
- 適切に処理を関数に分けて、そのテストコードを書きたい
- 検証環境、本番環境それぞれにデプロイしたい

## ローカルでLambdaを起動する

1. `cp .env.example .env`を叩いて.envを作成し、必要に応じて内容を編集する。
2. `./local_lambda_launcher.sh {lambda以下の動かしたいコードのディレクトリ名}`を叩いて起動する。
3. コンソールの表示に従って、curlなりを叩いて動作確認する。

## ローカルでLambdaのテストコードを実行する

`docker compose run --rm unittest {lambda以下の動かしたい~~_test.py}`を叩く。

## デプロイ

1. AWSの認証情報をコンソールの環境変数としてexportする。
2. `./deploy.sh {環境}`を叩く。
   1. `development`や`production`を指定する。厳密には環境を表すディレクトリ名を指定する。
