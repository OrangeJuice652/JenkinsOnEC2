# JenkinsOnEC2
JenkinsをインストールしたEC2を作成するためのCloudFormationテンプレート

## 使い方

下記コマンドを実行
```
aws cloudformation create-stack --stack-name JenkinsStack --template-body file://<jenkins_on_ec2_setup.yamlのファイルパス>　--parameters ParameterKey=VpcCIDR,ParameterValue=<VPCのCIDER範囲> ParameterKey=PublicSubnet1CIDR,ParameterValue=<パブリックサブネットのCIDER範囲>
```
