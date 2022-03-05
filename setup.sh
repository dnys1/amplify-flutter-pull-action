#!/bin/bash
#
# This script sets up the `amplify` executable. Instead of running `npm install -g @aws-amplify/cli`, 
# it downloads the pre-compiled version to improve performance.
#

set -e

if [[ -z "$AMPLIFY_VERSION" ]]; then
    AMPLIFY_VERSION=$(npm show @aws-amplify/cli version)
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS=linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS=macos
else
    echo "Unrecognized OS: $OSTYPE" >&2
    exit 1
fi

FILENAME=amplify-pkg-${OS}
curl -L -o amplify.tgz https://github.com/aws-amplify/amplify-cli/releases/download/v${AMPLIFY_VERSION}/${FILENAME}.tgz
tar -xzf amplify.tgz
chmod +x $FILENAME
mv $FILENAME /usr/local/bin/amplify
