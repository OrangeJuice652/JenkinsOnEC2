#!/bin/bash
# setup Jenkins on EC2
sudo yum update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-17-amazon-corretto-devel jenkins git -y
sudo wget https://raw.githubusercontent.com/OrangeJuice652/FlutterSetupOnLinux/main/flutter_setup_on_linux.sh -P ~jenkins/Downloads
sudo wget https://raw.githubusercontent.com/OrangeJuice652/FlutterSetupOnLinux/main/jenkins_plugin.sh -P ~jenkins/Downloads
sudo chown -R jenkins:jenkins ~jenkins/Downloads/
sudo chmod u+x ~jenkins/Downloads/flutter_setup_on_linux.sh
sudo chmod u+x ~jenkins/Downloads/jenkins_plugin.sh
sudo -u jenkins ~jenkins/Downloads/flutter_setup_on_linux.sh
sudo -u jenkins ~jenkins/Downloads/jenkins_plugin.sh
rm -r ~jenkins/Downloads
rm -r ~jenkins/tmp
sudo wget https://raw.githubusercontent.com/OrangeJuice652/JenkinsOnEc2/main/init_1_install_plugin.groovy -P ~/jenkins/init.groovy.d/
sudo wget https://raw.githubusercontent.com/OrangeJuice652/JenkinsOnEc2/main/init_2_set_up_job.groovy -P ~/jenkins/init.groovy.d/
sudo wget https://raw.githubusercontent.com/OrangeJuice652/JenkinsOnEc2/main/FlutterBuildPipline.xml -P ~/jenkins/FlutterBuildPipline.xml
# 環境変数のオーバーライド: https://www.jenkins.io/doc/book/system-administration/systemd-services/
# jenkins.install.runSetupWizard: https://www.jenkins.io/doc/book/managing/system-properties/
# systemctl editに標準入力をパイプ_1: https://bbs.archlinux.org/viewtopic.php?id=195782
# systemctl editに標準入力をパイプ_1: https://unix.stackexchange.com/questions/459942/using-systemctl-edit-via-bash-script
{
    echo "[Service]"; 
    echo "Environment="JAVA_OPTS=-Djenkins.install.runSetupWizard=false"";
} > ~jenkins/tmp/jenkins-override.conf
sudo env SYSTEMD_EDITOR="cp ~jenkins/tmp/jenkins-override.conf"
sudo systemctl edit jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins