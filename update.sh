#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )


for version in "${versions[@]}"; do	
  fullVersion="$(curl -fsSL "https://jfrog.bintray.com/artifactory-pro-debs/dists/trusty/main/binary-amd64/Packages.gz" | gunzip | awk -F ': ' '$1 == "Package" { pkg = $2 } pkg ~ /^jfrog-artifactory-pro$/ && $1 == "Version" { print $2 }' | grep "^$version" | sort -rV | head -n1 )"
	(
		set -x
		sed '
			s/%%ARTIFACTORY_MAJOR%%/'"$version"'/g;
			s/%%ARTIFACTORY_VERSION%%/'"$fullVersion"'/g;
		' Dockerfile.template > "$version/Dockerfile"
	)
done
