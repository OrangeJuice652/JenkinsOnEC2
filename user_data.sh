#!/bin/bash
# setup Jenkins on EC2
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
yum upgrade
yum install java-17-amazon-corretto-devel jenkins git -y
wget https://raw.githubusercontent.com/OrangeJuice652/FlutterSetupOnLinux/main/flutter_setup_on_linux.sh -P ~jenkins/Downloads
wget https://raw.githubusercontent.com/OrangeJuice652/FlutterSetupOnLinux/main/jenkins_plugin.sh -P ~jenkins/Downloads
chown -R jenkins:jenkins ~jenkins/Downloads/
chmod u+x ~jenkins/Downloads/flutter_setup_on_linux.sh
chmod u+x ~jenkins/Downloads/jenkins_plugin.sh
sudo -u jenkins ~jenkins/Downloads/flutter_setup_on_linux.sh
sudo -u jenkins ~jenkins/Downloads/jenkins_plugin.sh
systemctl enable jenkins
systemctl start jenkin