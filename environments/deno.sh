# runs on alpine

echo "Installing Deno"

apk update && apk add curl

curl -fsSL https://deno.land/x/install/install.sh | sh

mv /root/.deno/bin/deno /bin/deno

deno --version
