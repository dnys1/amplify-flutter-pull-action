# Amplify Flutter Pull

Pulls an Amplify Flutter project in a Github Action.

## Getting Started

1. Follow the [Github guide](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) for creating an OIDC provider in IAM.
2. Create a policy with the following permissions and attach it to the role.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "amplify:GetBackendEnvironment",
        "amplify:GetApp",
        "cloudformation:ListStackResources",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": "*"
    }
  ]
}
```

## Usage

Configure your action's environment with the role ARN from the previous step, the app ID of your Amplify project, and the name of the Amplify environment to pull.

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
      contents: read

    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Amplify Flutter Pull
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
