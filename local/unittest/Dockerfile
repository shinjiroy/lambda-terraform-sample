FROM python:3.12-slim-bullseye

# boto3は固定で入れる ※AWS Lambdaではデフォルトで入っている
RUN pip install boto3

# 全部のrequirements.txtをマージしてからpip installする
# ホントはバージョン被ったりして良くないですが、unittest用なので許してクレメンス
COPY ./local/lambda /tmp/lambda
RUN find /tmp/lambda -name "requirements.txt" -exec cat {} \; >> /tmp/all_requirements.txt
RUN pip install -r /tmp/all_requirements.txt
RUN rm -rf /tmp/lambda /tmp/all_requirements.txt
