#!/bin/bash
# Submission should complete successfully.
buildId="opinionated-pipeline-test"
gcloud builds submit . --config cloudbuild.yaml --substitutions "_REPO_TO_CLONE=https://github.com/brianpipeline/test-cloudbuild.git,_REPO_NAME="test-cloudbuild",_SHORT_BUILD_ID=$buildId" --region=us-central1

# Submission should fail and downstream pipeline should receive a 'Pipeline failed', and delete the pipeline accordingly.
buildId="opinionated-pipeline-test"
if gcloud builds submit . --config cloudbuild.yaml --substitutions "_REPO_TO_CLONE=https://github.com/brianpipeline/test-cloudbuild-failure.git,_REPO_NAME="test-cloudbuild-failure",_SHORT_BUILD_ID=$buildId" --region=us-central1; then
    exit 1
fi
message=$(gcloud pubsub subscriptions pull "subscription_$buildId" --format='value(message.data)')
if [[ $message != "Pipeline failed." ]]; then
    echo "Wrong message was sent to the downstream pipeline."
    exit 1
fi
