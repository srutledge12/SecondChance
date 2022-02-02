#!/bin/bash

set -e
IFS='|'
args=("$@")

appId=""
envName=""
useProfile="true"
profileName="default"
accessKey=""
secretKey=""
for ((argPos=0; argPos <= ${#args}; argPos++))
do
  if [ "${args[$argPos]}" == "--appid" ]; then
    appId="${args[(($argPos+1))]}"
    argPos=$((argPos+1))
  elif [ "${args[$argPos]}" == "--envName" ]; then
    envName="${args[(($argPos+1))]}"
    argPos=$((argPos+1))
  elif [ "${args[$argPos]}" == "--accessKey" ]; then
    accessKey="${args[(($argPos+1))]}"
    argPos=$((argPos+1))
  elif [ "${args[$argPos]}" == "--secretKey" ]; then
    secretKey="${args[(($argPos+1))]}"
    argPos=$((argPos+1))
  fi
done

AWSCLOUDFORMATIONCONFIG="{\
\"configLevel\":\"project\",\
\"useProfile\":${useProfile},\
\"accessKeyId\":\"${accessKey}\",\
\"secretAccessKey\":\"${secretKey}\",\
\"profileName\":\"${profileName}\"\
}"
AMPLIFY="'{\
\"appId\":\"${appId}\",\
\"defaultEditor\":\"code\",\
\"envName\":\"${envName}\"\
}'"
PROVIDERS="'{\
\"awscloudformation\":$AWSCLOUDFORMATIONCONFIG\
}'"

cmd="amplify pull --providers ${PROVIDERS} --amplify ${AMPLIFY} --yes"
echo $cmd
eval $cmd
