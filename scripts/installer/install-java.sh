#!/bin/bash
set -euo pipefail

echo "Installing Java development tools..."

# Install OpenJDK
sudo apt-get update -qq
sudo apt-get install -y -qq \
    openjdk-17-jdk \
    maven \
    gradle

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "Java setup complete."
java -version