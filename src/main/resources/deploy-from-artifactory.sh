#!/bin/bash

ARTIFACTORY_URL=https://cloudnativejava.artifactoryonline.com/cloudnativejava
curl -v -X POST -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD  "$ARTIFACTORY_URL/api/search/aql" -Tsearch.aql

# from the results of that grab: repo + path + name

A_REPO=libs-snapshot-local
A_PATH=com/example/ci-cd/0.0.1-SNAPSHOT
A_NAME=ci-cd-0.0.1-20151028.204330-11.jar

ARTIFACT_URL=$ARTIFACTORY_URL/$A_REPO/$A_PATH/$A_NAME
echo $ARTIFACT_URL

# now we have resolved the URL, lets set a property to mark it ready for production
curl -v -X PUT  -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD $ARTIFACTORY_URL/api/storage/$A_REPO/$A_PATH/$A_NAME?properties=env=prod

# now let's requery for the latest version that is suitable for this environment
## i _could_ deploy specifically what was approved and what matched the COMMIT_ID, but really if there's another build
# that came later, and it was _also_ marked for production, then I want _THAT_ one.
LATEST_PROD=https://cloudnativejava.artifactoryonline.com/cloudnativejava/libs-snapshot-local/com/example/ci-cd/0.0.1-SNAPSHOT/ci-cd-0.0.1-SNAPSHOT.jar;env+=prod

# deploy $LATEST_PROD 



# from here something needs to actually then deploy the code to production. In our case, this is just a simple cf mapping of URIs. blue/green deployments FTW!
# JFrog supports callbacks so you can say, for example, that when a property is changed it should trigger behavior



####
