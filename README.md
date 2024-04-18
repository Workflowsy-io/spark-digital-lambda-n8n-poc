# POC-spark-digital-http-n8n - AWS Lambda URL Request Function with IAM User

This repository includes a comprehensive suite of tools, comprising an AWS CloudFormation template and a shell script, designed to automate the deployment of an AWS Lambda function capable of making HTTP requests based on provided URLs, and an IAM user with full access to manage AWS Lambda operations.

## Description

The CloudFormation template provided in this repository will configure the following AWS resources:

- **AWS Lambda Function**: Executes HTTP GET requests to URLs specified in incoming event payloads. This function is designed for dynamic interaction based on HTTP requests.
- **IAM User**: This IAM user is equipped with access keys and is assigned a policy that grants extensive access to AWS Lambda functionalities.
- **Lambda Layer**: Includes the `requests` Python library, which is not natively available in the AWS Lambda environment but is necessary for making HTTP requests.

Additionally, a shell script is provided to automate the setup process including the packaging of necessary libraries, creation of AWS resources, and deployment.

## Setup

### Prerequisites

Before proceeding with the deployment, ensure the following prerequisites are met:

- **AWS CLI**: Installed and configured with credentials that have permissions to create the resources required by this template.
- **Python & pip**: Installed on your machine to handle dependencies and packaging of the Lambda layer.

### Repository Structure

- `lambda_stack.yaml`: The AWS CloudFormation template.
- `deploy.sh`: The shell script that automates the entire end-to-end deployment process.

### Deployment

To deploy the resources, follow these steps:

1. **Clone the Repository**:
   Clone this repository to your local environment to get started with the deployment.
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Run the Deployment Script**:
   Execute the `deploy.sh` script, which automates the setup:
   ```bash
   ./deploy.sh
   ```
   This script will:
   - Check for correct AWS CLI configuration.
   - Create a uniquely named S3 bucket.
   - Install the `requests` library in the local environment.
   - Package this library into a zippable Lambda layer.
   - Upload the package to the S3 bucket.
   - Deploy the CloudFormation stack using provided parameters.

### Outputs

Upon successful deployment via CloudFormation, the following output values will be displayed:

- **LambdaFunctionName**: The name of the Lambda function deployed.
- **LambdaFunctionArn**: The AWS Resource Name (ARN) for the Lambda function.
- **IAMUserName**: Username for the created IAM user.
- **IAMUserAccessKeyId**: Access key ID for the IAM User.
- **IAMUserSecretAccessKey**: Secret access key for the IAM user. (Handle this value with the utmost security).

### Post-Deployment

**IAM Credentials Handling**:
- Ensure that the IAM user credentials are stored securely and are not exposed in insecure environments. Utilize AWS Secrets Manager or other secure mechanisms for managing sensitive data.

**Permissions Review**:
- Consider revising the permissions assigned to the IAM user, ensuring they adhere to the Principle of Least Privilege (PoLP).

## Contributing

Contributions to this project are welcome! Please feel free to fork the repository, make changes, and submit pull requests. For major changes or enhancements, opening an issue to discuss your ideas would be appreciated.

## Support

If you encounter any issues during the deployment or have questions regarding this setup, please open an issue in this repository. For more detailed assistance, you may also refer to the AWS documentation or seek help via AWS Support.