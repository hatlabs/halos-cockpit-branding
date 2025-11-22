#!/bin/bash
# Build Debian package (.deb) in debtools container

set -e

echo "Building Debian package in Debian trixie container..."

# Build the package inside debtools container
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  debtools:latest \
  bash -c "dpkg-buildpackage -b -uc -us && mv ../*.deb ./ && mv ../*.buildinfo ../*.changes ./ 2>/dev/null || echo 'Note: Some auxiliary files not found'"

# List generated packages
echo "Generated packages:"
ls -lh *.deb

echo "Package build complete"
