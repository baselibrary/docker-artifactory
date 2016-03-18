#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )


for version in "${versions[@]}"; do	
  repoPackage="https://jfrog.bintray.com/artifactory-pro-debs/dists/trusty/main/binary-amd64/Packages.gz"
  fullVersion="$(curl -fsSL "${repoPackage}" | gunzip | awk -v pkgname="jfrog-artifactory-pro" -F ': ' '$1 == "Package" { pkg = $2 } pkg == pkgname && $1 == "Version" { print $2 }' | grep "^$version" | sort -rV | head -n1 )"
  (
		set -x
		sed '
			s/%%ARTIFACTORY_MAJOR%%/'"$version"'/g;
			s/%%ARTIFACTORY_VERSION%%/'"$fullVersion"'/g;
		' Dockerfile.template > "$version/Dockerfile"
	)
done
