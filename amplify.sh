#!/bin/bash

set -e
IFS='|'
args=("$@")

appId=""
envName=""
useProfile="false"
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
\"region\":\"us-east-2\",\
\"profileName\":\"${profileName}\"\
}"
AMPLIFY="'{\
\"appId\":\"${appId}\",\
\"defaultEditor\":\"android studio\",\
\"envName\":\"${envName}\"\
}'"
PROVIDERS="'{\
\"awscloudformation\":$AWSCLOUDFORMATIONCONFIG\
}'"

CONFIG="{\
\"SourceDir\":\"lib\",\
\"ResDir\":\"lib\",\
\"DistributionDir\":\"build\"\
}"

FRONTEND="'{\
\"frontend\":\"flutter\",\
\"config\":$CONFIG\
}'"
cmd="amplify pull --providers ${PROVIDERS} --amplify ${AMPLIFY} --frontend ${FRONTEND} --yes"
echo $cmd
eval $cmd
