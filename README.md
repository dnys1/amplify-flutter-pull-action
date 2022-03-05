# Amplify Flutter Pull

Pulls an Amplify Flutter project in a Github Action.

## Getting Started

1. Follow the [Github guide](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) for creating an OIDC provider and role in IAM.
2. Create a policy with the following permissions and attach it to the role, replacing `<PROJECT_NAME>` and `<ENV_NAME>` with your Amplify project's name and environment name.

```json
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "amplify:GetApp",
          "amplify:GetBackendEnvironment",
          "cloudformation:ListStackResources"
        ],
        "Resource": "*",
        "Condition": {
          "StringEqualsIfExists": {
              "aws:ResourceTag/user:Application": "<PROJECT_NAME>"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::amplify-<PROJECT_NAME>-<ENV_NAME>-*"
        ]
      }
  ]
}
```

## Usage

Configure your action's environment with the role ARN from the previous step, the app ID of your Amplify project, and the AWS region of your project. Optionally, you can set the name of the Amplify environment to pull, and the version of the CLI to use.

```yaml
name: Build
on:
  push:
  pull_request:

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest

    # Required for AWS credentials action
    permissions:
      id-token: write

    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Pull Amplify project
        uses: dnys1/amplify-flutter-pull-action@v1
        with:
          region: ${{ secrets.REGION }}
          app-id: ${{ secrets.APP_ID }}
          role-arn: ${{ secrets.ROLE_ARN }}
```

See the [Habitr](https://github.com/dnys1/habitr/blob/main/.github/workflows/deployment.yaml) project for a full example.

## Configuration

The action supports the following inputs:

| Input Name | Required | Default | Description |
| ---------- | -------- | ------- | ----------- |
| app-id | x | | The Amplify App ID of your project. |
| role-arn | x | | The Role ARN from `Getting Started`. |
| region | x | | The AWS region where your project is hosted. |
| env-name | | `dev` | The Amplify environment to pull. |
| version | | latest | The Amplify CLI version to use. |
