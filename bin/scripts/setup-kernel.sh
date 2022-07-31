#!/bin/bash

KERNEL_VERSION=$1

build_kernel(){
	make -j16 &&
    make modules_install
}

install_kernel() {
	cp -v arch/x86/boot/bzImage /boot/vmlinuz-lfs
	cp -v System.map /boot/System.map
	cp -v .config /root/config_$(date '+%m.%d.%Y_%H%M')
}

main() {
  pushd "/usr/src/linux-${KERNEL_VERSION}" || exit 1
  build_kernel || exit 1
  install_kernel || exit 1
  popd || exit 1
}

main
