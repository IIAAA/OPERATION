#!/bin/bash
install_jdk(){
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-headless
}
install_tomcat(){
cd /root/
tar -xf lnmp_soft.tar.gz
cd lnmp_soft/
tar -xf apache-tomcat-8.0.30.tar.gz
mv apache-tomcat-8.0.30 /usr/local/tomcat
}
start_tomcat(){
/usr/local/tomcat/bin/startup.sh
}
reload_tomcat(){
/usr/local/tomcat/bin/shutdown.sh
/usr/local/tomcat/bin/startup.sh
}
stop_tomcat(){
/usr/local/tomcat/bin/shutdown.sh
}
s_random(){
mv /dev/random  /dev/random.bak
ln -s /dev/urandom  /dev/random
}
host_create_conf(){
sed -i '139a<Host name="www.a.com" appBase="a" unpackWARS="true" autoDeploy="true"></Host>' /usr/local/tomcat/conf/server.xml
sed -i '140a<Host name="www.b.com" appBase="b" unpackWARS="true" autoDeploy="true"></Host>' /usr/local/tomcat/conf/server.xml
}
dir_create_html(){
mkdir -p /usr/local/tomcat/{a,b}/ROOT
}
tomcat_html_create(){
echo "AAA" > /usr/local/tomcat/a/ROOT/index.html
echo "BBB" > /usr/local/tomcat/b/ROOT/index.html
} 
change_index(){
sed -i '140c<Host name="www.a.com" appBase="a" unpackWARS="true" autoDeploy="true"><Context path="" docBase="base" reloadable="true"/></Host>' /usr/local/tomcat/conf/server.xml
mkdir /usr/local/tomcat/a/base
echo "BASE" > /usr/local/tomcat/a/base/index.html
}
install_httpd(){
yum -y install httpd
}
stop_httpd(){
systemctl stop httpd
}
start_httpd(){
systemctl start httpd
}
restart_httpd(){
systemctl restart httpd
}
skip_index(){
sed -i '141c<Host name="www.b.com" appBase="b" unpackWARS="true" autoDeploy="true"><Context path="/test" docBase="/var/www/html/" /></Host>' /usr/local/tomcat/conf/server.xml
echo "Test" > /var/www/html/index.html
}
install_expect(){
yum -y install expect
}
sslkey_create(){
expect << EOF
spawn keytool -genkeypair -alias tomcat -keyalg RSA -keystore /usr/local/tomcat/keystore
expect "口令" {send "123456\r"}
expect "新口令" {send "123456\r"}
expect "Unknown" {send "yid\r"}
expect ":" {send "tedu\r"}
expect ":" {send "\r"}
expect ":" {send "\r"}
expect ":" {send "\r"}
expect ":" {send "\r"}
expect ":" {send "cn\r"}
expect "否" {send "yes\r"}
expect "回车" {send "123456\r"}
expect "新口令" {send "123456\r"}
expect "#"          { send "exit\r" }
EOF
}
sslkey_tomcat_conf(){
sed -i '84,88s/.*//' /usr/local/tomcat/conf/server.xml
sed -i '85c<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"' /usr/local/tomcat/conf/server.xml
sed -i '87cmaxThreads="150" SSLEnabled="true" scheme="https" secure="true"' /usr/local/tomcat/conf/server.xml
sed -i '88ckeystoreFile="/usr/local/tomcat/keystore" keystorePass="123456" clientAuth="false" sslProtocol="TLS" />' /usr/local/tomcat/conf/server.xml
}
tomcat_log_conf(){
sed -i '140c<Host name="www.a.com" appBase="a" unpackWARS="true" autoDeploy="true"><Context path="" docBase="base" reloadable="true"/><Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs" prefix=" a_access" suffix=".txt" pattern="%h %l %u %t &quot;%r&quot; %s %b" /></Host>' /usr/local/tomcat/conf/server.xml
sed -i '141c<Host name="www.b.com" appBase="b" unpackWARS="true" autoDeploy="true"><Context path="/test" docBase="/var/www/html/" /><Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs" prefix=" b_access" suffix=".txt" pattern="%h %l %u %t &quot;%r&quot; %s %b" /></Host>' /usr/local/tomcat/conf/server.xml
}
install_jdk
install_tomcat
start_tomcat
