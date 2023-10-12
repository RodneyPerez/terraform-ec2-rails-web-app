#!/bin/bash
instance_id=$(curl -fs http://169.254.169.254/latest/meta-data/instance-id | sed -e 's/i-//g')
new_hostname=$instance_id.${Environment}.sfc.net
echo $new_hostname > /etc/hostname
echo "127.0.0.1 $(new_hostname)" > /etc/hosts
echo 'export AWS_REGION=${region}' >> /tmp/.env_${Application}
echo 'export AWS_ENV_PATH=/${Application}/${Environment}/' >> /tmp/.env_${Application}
echo "source /tmp/.env_${Application}" >> /home/ubuntu/.bashrc
hostname $new_hostname
apt-get update -y
apt-get install -y python-pip
apt-get install -y python-setuptools
mkdir -p /opt/aws/bin
python /usr/lib/python2.7/dist-packages/easy_install.py --script-dir /opt/aws/bin https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
source /tmp/.env_${Application}
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
