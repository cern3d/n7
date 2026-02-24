#!/bin/bash

# Stop the script if any command fails
set -e

echo "Compiling Java files..."
javac *.java

echo "Creating MyAgent.jar..."
jar cvf MyAgent.jar \
    Hotels.class \
    Compression.class \
    AgentImpl.class \
    Agent.class \
    Node.class \
    NodeInt.class \
    MoveException.class


