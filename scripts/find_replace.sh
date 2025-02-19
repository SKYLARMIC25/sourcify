#!/bin/bash
set -e

source ~/.profile

cd scripts/
gpg --yes --batch --passphrase=$SECRET_KEY ../environments/.env.secrets.gpg
gpg --yes --batch --passphrase=$SECRET_KEY ../services/ipfs/ipfs-stable.key.gpg
gpg --yes --batch --passphrase=$SECRET_KEY ../services/ipfs/ipfs-latest.key.gpg
source ../environments/.env.secrets

TAG="$CIRCLE_BRANCH"

if [ "$CIRCLE_BRANCH" == "staging" ]; then
    TAG="latest"
    INFURA_ID=$INFURA_ID_STAGING
    ALCHEMY_ID=$ALCHEMY_ID_STAGING
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_STAGING
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_STAGING
    IPFS_SECRET=$IPFS_SECRET_STAGING
fi

if [ "$CIRCLE_BRANCH" == "master" ]; then
    TAG="stable";
    INFURA_ID=$INFURA_ID_MASTER
    ALCHEMY_ID=$ALCHEMY_ID_MASTER
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_MASTER
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_MASTER
    IPFS_SECRET=$IPFS_SECRET_MASTER
fi

for VAR_NAME in INFURA_ID ALCHEMY_ID AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY IPFS_SECRET NPM_TOKEN ENS_SECRET
do
    VAR_VAL=$(eval "echo \${$VAR_NAME}")
    sed -i "s/${VAR_NAME}=xxx/${VAR_NAME}=${VAR_VAL}/g" ../environments/.env.$TAG
done

cp ../environments/.env.$TAG ../environments/.env
rm ../environments/.env.secrets
