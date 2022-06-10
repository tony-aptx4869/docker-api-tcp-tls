#! /bin/bash
## A Shell script to generate certs for TLS security on a Linux OS.
## Author: Tony Chang <tonychang7869@gmail.com>
## GitHub Repo: https://github.com/tony-aptx4869/docker-api-tcp-tls

echo "################################################################"
echo "#            TLS Certs Genetating Script for Linux             #"
echo "################################################################"

echo -e "\033[1;42;39mPREPARATION: \033[0;42;39mCreate a directory for generating TLS Certs files.\033[0m"
mkdir certs
cd certs

echo -e "\033[1;42;39mSTEP 1: \033[0;42;39mGenerate CA Private Key file \`ca-key.pem\`.\033[0m"
echo -e "\033[1;31mPlease enter pass phrase for \`ca-key.pem\` twice. And Please Remember that, you'll use it soon.\033[0m"
openssl genrsa -aes256 -out ca-key.pem 4096
echo ""

echo -e "\033[1;42;39mSTEP 2: \033[0;42;39mGenerate CA Cert \`ca.pem\`.\033[0m"
echo -e "\033[1;31mYou need to enter the pass phrase for \`ca-key.pem\` to continue.\033[0m"
echo -e "\033[1;31mAnd then you need to enter some relevant information as required, please refer to the example in the yellow area below.\033[0m"
echo -e "\033[0;43;30mCountry Name (2 letter code) []: \033[1;43;39mCN\033[0m"
echo -e "\033[0;43;30mState or Province Name (full name) []: \033[1;43;39mBeijing\033[0m"
echo -e "\033[0;43;30mLocality Name (eg, city) []: \033[1;43;39mBeijing\033[0m"
echo -e "\033[0;43;30mOrganization Name (eg, company) []: \033[1;43;39mAPTX4869\033[0m"
echo -e "\033[0;43;30mOrganizational Unit Name (eg, section) []:\033[0m"
echo -e "\033[0;43;30mCommon Name (eg, fully qualified host name) []: \033[1;43;39maptx4869.app\033[0m"
echo -e "\033[0;43;30mEmail Address []: \033[1;43;39mYOUR@EMAIL.ADDRESS\033[0m"
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
echo ""

echo -e "\033[1;42;39mSTEP 3: \033[0;42;39mGenerate Server Private Key file \`server-key.pem\`.\033[0m"
openssl genrsa -out server-key.pem 4096
echo ""

echo -e "\033[1;42;39mSTEP 4: \033[0;42;39mGenerate Server Cert file \`server-cert.pem\`.\033[0m"
echo -e "\033[1;31mYou need to enter the pass phrase for \`ca-key.pem\` to continue.\033[0m"
openssl req -subj "/CN=tony1069.i234.me" -sha256 -new -key server-key.pem -out server.csr
echo subjectAltName = DNS:tony1069.i234.me,IP:0.0.0.0 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
echo ""

echo -e "\033[1;42;39mSTEP 5: \033[0;42;39mGenerate Client Private Key file \`key.pem\`.\033[0m"
openssl genrsa -out key.pem 4096
echo ""

echo -e "\033[1;42;39mSTEP 6: \033[0;42;39mGenerate Server Cert file \`cert.pem\`.\033[0m"
echo -e "\033[1;31mYou need to enter the pass phrase for \`ca-key.pem\` to continue.\033[0m"
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf
echo ""

rm -f ca-key.pem ca.srl client.csr extfile-client.cnf extfile.cnf server.csr
