#!/bin/bash

# Stop the script if any command fails
set -e

echo "Compiling Java files..."
javac *.java

echo "Running StarterCompression..."
java ServerCompression 2002

