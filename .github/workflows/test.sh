#!/bin/sh
# TODO: move the template test to flake check
LA=$(pwd)
TEST_DIR=.test-project
TMP_LA=/tmp/la-ctl
set +ex
rm -Rf $TMP_LA
rm -Rf $TEST_DIR
set -ex
nix flake check --show-trace
cp -Rf . $TMP_LA
FILE=$TMP_LA/nix/template/flake.nix
sed -i "s|github:LovelaceAcademy/la-ctl|path:$LA|g" $FILE
mkdir $TEST_DIR
(
	cd $TEST_DIR
	git init
	nix flake init -t $TMP_LA
	nix flake check --show-trace
)
