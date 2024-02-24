# AWS Lambdaがサポートする最新のバージョンで試しましょう
# https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-runtimes.html
# https://gallery.ecr.aws/lambda/python
# ※とはいえきちんとAWSにデプロイしてからテストしましょう。あくまでコードをローカルで書きながら簡単に動かす用です。
FROM public.ecr.aws/lambda/python:3.12

# boto3は固定で入れる ※AWS Lambdaではデフォルトで入っている
RUN pip install boto3

# ここからLambda毎の設定
ARG TARGET_LAMBDA_NAME

# 先にpip installから終わらせておく
COPY ./lambda/${TARGET_LAMBDA_NAME}/requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

# ソースコードを配置
ADD ./lambda/${TARGET_LAMBDA_NAME}/ ${LAMBDA_TASK_ROOT}
