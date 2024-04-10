#!/bin/bash
# Submission should should complete successfully.
buildId="opinionated-pipeline-test"
gcloud builds submit . --config cloudbuild.yaml --substitutions "_REPO_TO_CLONE=https://github.com/brianpipeline/test-cloudbuild.git,_REPO_NAME="test-cloudbuild",_SHORT_BUILD_ID=$buildId" --region=us-central1
