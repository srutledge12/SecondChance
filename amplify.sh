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
<<<<<<< HEAD
\"accessKeyId\":\"${accessKey}\",\
\"secretAccessKey\":\"${secretKey}\",\
=======
\"accessKeyId\":${accessKey},\
\"secretAccessKey\":${secretKey},\
>>>>>>> Lucas
\"profileName\":\"${profileName}\"\
}"
AMPLIFY="'{\
\"appId\":\"${appId}\",\
<<<<<<< HEAD
\"defaultEditor\":\"code\",\
=======
>>>>>>> Lucas
\"envName\":\"${envName}\"\
}'"
PROVIDERS="'{\
\"awscloudformation\":$AWSCLOUDFORMATIONCONFIG\
}'"

cmd="amplify pull --providers ${PROVIDERS} --amplify ${AMPLIFY} --yes"
echo $cmd
eval $cmd
