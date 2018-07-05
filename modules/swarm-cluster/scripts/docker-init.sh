#!/bin/bash

if [[ ! -z "${QUAY_USERNAME}" && ! -z "${QUAY_PASSWORD}" ]]; then
  docker login -u=${QUAY_USERNAME} \
  -p=${QUAY_PASSWORD} \
  quay.io
fi

if [[ ! -z "${AWS_ACCESSKEY}" && ! -z "${AWS_SECRETKEY}" ]]; then
  docker plugin install rexray/s3fs:0.11.1 \
    --grant-all-permissions \
    S3FS_REGION=${AWS_REGION} \
    S3FS_ACCESSKEY=${AWS_ACCESSKEY} \
    S3FS_SECRETKEY=${AWS_SECRETKEY}

  docker plugin install rexray/ebs \
    --grant-all-permissions \
    EBS_REGION=${AWS_REGION} \
    EBS_ACCESSKEY=${AWS_ACCESSKEY} \
    EBS_SECRETKEY=${AWS_SECRETKEY}
fi
