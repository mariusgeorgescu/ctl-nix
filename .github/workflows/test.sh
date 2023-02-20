#!/bin/bash
CTL=$(pwd)
TEST_DIR=$(mktemp)
set +ex
rm -Rf $TEST_DIR
set -ex
mkdir $TEST_DIR
(
	cd $TEST_DIR
	git init
	nix flake init -t github:LovelaceAcademy/nix-templates#ctl-full
	sed -i "s|github:LovelaceAcademy/ctl-nix|path:$CTL|g" flake.nix
	nix build --show-trace -L
	nix flake check --show-trace
)
