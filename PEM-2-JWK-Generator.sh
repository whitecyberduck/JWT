#!/bin/bash
## Requires openssl, nodejs, jq
## original source shu-yusa/create_jwt.sh https://gist.github.com/shu-yusa/213901a5a0902de5ad3f62a61036f4ce

# Checking if private key exists and, if not, generates a private-public pair
if [ ! -f private.pem ]; then
  openssl genrsa 2048 > private.pem
  openssl rsa -in private.pem -pubout -out public.pem
fi

# Create JWK from public key
mkdir node_modules
if [ ! -d ./node_modules/pem-jwk ]; then
  npm install pem-jwk
fi
jwk=$(./node_modules/.bin/pem-jwk public.pem)

# Add additional fields
jwk=$(echo '{"use":"sig"}' $jwk $header | jq -cs add)

# Print out and save JWK to the screen
echo '{"keys":['$jwk']}'| jq . > JWK.json
echo -e "\n--- JWK ---"
jq . JWK.json 
