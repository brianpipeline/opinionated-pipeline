#!/bin/bash
# Submission should complete successfully.
buildId="opinionated-pipeline-test"
gcloud builds submit . --config cloudbuild.yaml --substitutions "_GIT_CLONE_URL=https://github.com/brianpipeline/test-cloudbuild.git,_GIT_REPOSITORY_NAME="test-cloudbuild",_GIT_REF="refs/heads/main",_GIT_HEAD_SHA="d4828ea0e1bca17e8f6a4cc387d5bbaf33714566",_SHORT_BUILD_ID=$buildId" --region=us-central1

# Submission should fail and downstream pipeline should receive a 'Pipeline failed', and delete the pipeline accordingly.
buildId="opinionated-pipeline-test"
if gcloud builds submit . --config cloudbuild.yaml --substitutions "_GIT_CLONE_URL=https://github.com/brianpipeline/test-cloudbuild-failure.git,_GIT_REPOSITORY_NAME="test-cloudbuild-failure",_GIT_REF="refs/heads/main",_GIT_HEAD_SHA="b3fa043e677500882e689fc1a978d96056d6702d",_SHORT_BUILD_ID=$buildId" --region=us-central1; then
    exit 1
fi
if gcloud pubsub subscriptions describe "subscription_$buildId"; then
    echo "Subscription was not deleted"
    exit 1
fi

if gcloud pubsub topics describe "topic_$buildId"; then
    echo "Topic was not deleted"
    exit 1
fi