#!/bin/bash

# Variables
layer_name="requests_layer"
bucket_name="my-unique-bucket-name-$(date +%s)"   # Using timestamp to ensure uniqueness
build_dir="./${layer_name}/python"
layer_zip="${layer_name}.zip"
s3_key="lambda-layers/${layer_zip}"
stack_name="LambdaWithLayerStack"
template_file="lambda_stack.yaml"

# Create directory structure for Lambda Layer
mkdir -p "${build_dir}"

# Install the 'requests' library in the layer folder
pip install requests -t "${build_dir}"

# Package Lambda Layer
cd "${layer_name}"
zip -r "../${layer_zip}" .

# Move back to original directory
cd ..

# Ensure AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null; then
  echo "AWS CLI is not configured properly."
  exit 1
fi

# Create S3 bucket (if does not exist or need to specify settings, consider handling bucket creation or existence check here)
if aws s3 ls "s3://${bucket_name}" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "Bucket does not exist, creating new bucket: ${bucket_name}"
  aws s3 mb "s3://${bucket_name}"
fi

# Upload the packaged layer to S3
aws s3 cp "${layer_zip}" "s3://${bucket_name}/${s3_key}"

# Clean up local files
rm -rf "${layer_name}"
rm "${layer_zip}"

# Deploy the CloudFormation stack
aws cloudformation deploy \
    --template-file "${template_file}" \
    --stack-name "${stack_name}" \
    --parameter-overrides LayerBucketName="${bucket_name}" LayerZipKey="${s3_key}" \
    --capabilities CAPABILITY_NAMED_IAM

echo "Lambda layer packaged and uploaded successfully to ${bucket_name}/${s3_key}"
echo "CloudFormation stack '${stack_name}' is being deployed..."
