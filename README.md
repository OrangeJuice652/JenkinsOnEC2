# JenkinsOnEC2

## 概要

[作成したFlutterアプリケーション](https://github.com/OrangeJuice652/YourFirstFlutterApp)をビルド -> AwsDeviceFarmを使用したUI確認の自動テスト
を行う環境をセットアップするリポジトリ。

## 構成図

![](./static/jenkins_on_ec2_diagram.png)

上図は、自動テスト環境のインフラ構成図である。
上図の環境は、本リポジトリの[jenkins_on_ec2_setup.yaml](./jenkins_on_ec2_setup.yaml)を使い、CloudFormationで作成できる。

### EC2に使用するAMI

- amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2

## 作成した自動テスト環境

![](./static/flutter_build_pipline.png)

上図は、作成したJenkinsにあるFlutterBuildPiplineの自動テストの流れである。

1. Flutterソースコードを取得
  1. 指定したgithubリポジトリからソースコードをプルする。
2. Jenkinsサーバー内で、手順1. でプルしたソースコードをビルドする。
3. ビルドしたファイルをAWSDeviceFarmに送信してテスト実行。


***

## セットアップ手順

AWS環境を作成し、Jenkinsをセットアップするまでの手順を記載する。

1. スタック作成

```
aws cloudformation create-stack --stack-name JenkinsStack --template-body file://<jenkins_on_ec2_setup.yamlのファイルパス>　--parameters ParameterKey=VpcCIDR,ParameterValue=<VPCのCIDER範囲> ParameterKey=PublicSubnet1CIDR,ParameterValue=<パブリックサブネットのCIDER範囲>
```

2. Jenkinsにアクセス

```
URL: http://<EC2のパブリックIP>:8080/
```

Jenkins起動時に、
- Pluginのインストール
- パイプラインのインポート
を自動で行うため※、
GUIでの初期設定は不要。

※ 起動時のスクリプトは、本リポジトリ`groovy`ディレクトリ配下

***

## コマンドのメモ

上記にない便利なコマンドのメモ

### スタック削除
```
aws cloudformation delete-stack --stack-name JenkinsStack
```

### Device Farm用のIAMスタックの作成

```
aws cloudformation create-stack --stack-name AWSDeviceFarmUserStack --template-body file://<aws_device_farm_iam_user.yamlのファイルパス> --capabilities CAPABILITY_NAMED_IAM
```

## TODO

### Jenkinsの不具合・改善

- Jenkins内のユーザーをgroovyで作成する。
  - use_data内で、`Djenkins.install.runSetupWizard=false`を設定しているため、認証機能がoffになっている。
    - GUIでのセットアップウィザードではなく、groovyでセットアップを行うため設定した。
  - groovyスクリプト内で、ユーザーを作成し、認証機能をonにする。

- Jenkinsの設定画面（/manage/configure）にあるDeviceFarmプラグイン設定を、groovyで自動設定できるようにする。
  - AKID（アクセスキー）、SKID（シークレットアクセスキー）を設定する。

### README・資料への追記
- AWS構成図に追記
  - 元になったAMI
  - CloudFormationのノード追記
- ファイルの内訳記載
- 途中でDeviceFarmジョブが止まってしまう不具合を書く

## メモ

### Jenkinsジョブをエクスポート

既存のJenkinsから、ジョブをエクスポートする。
[参考](https://www.jenkins.io/doc/book/managing/cli/)

1. jenkins-cli.jarを、ローカル環境にダウンロード
  - ダウンロード先：`<JenkinsのURL>/jnlpJars/jenkins-cli.jar`

2. ジョブ名を取得
  -  `java -jar ./jenkins-cli.jar -s <JenkinsのURL> -auth <ユーザー名>:<パスワード(環境変数で参照すること推奨)> list-jobs`

3. ジョブをエクスポート
  -  `java -jar ./jenkins-cli.jar -s <JenkinsのURL> -auth <ユーザー名>:<パスワード(環境変数で参照すること推奨)> get-job > hoge.xml`

### SSH接続手順

CloudFormationで作成したEC2に、SSH接続するためのメモ

1. 作成したKeyPairから、EC2にSSH接続

- [CloudFormationで作成したキーペアを取得＆~/.ssh配下に保存するスクリプト](https://github.com/OrangeJuice652/SaveCloudFormationKeyPair/tree/main)

 - コマンド
 ```
 ./SaveCloudFormationKeyPair/save_cloudformation_keypair.sh JenkinsStack JenkinsInstanceKeyPairID JenkinsInstanceKeyPair
 ```

- スクリプトを使用しない場合は、~/.ssh配下で、パラメータストア（/ec2/keypair/作成したキーペアID）記載のキー値を保存

2. EC2にssh接続

```
ssh -i "~/.ssh/<手順2.で作成したキーファイル>" ec2-user@<EC2のパブリックIP>
```