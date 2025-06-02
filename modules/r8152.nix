{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  pname = "r8152";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "wget";
    repo = "realtek-r8152-linux";
    rev = "v${version}";
    sha256 = "sha256-c84VZBShuTbz4/u3SI1b8V5strWiOwam4vZfqaTFRW4=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  # Set the proper build environment
  preBuild = ''
    # Export variables that the Makefile expects
    export KERNELRELEASE="${kernel.modDirVersion}"
    export KERNEL_DIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export KVER="${kernel.modDirVersion}"
    
    # Parse kernel version numbers that the Makefile expects
    # NixOS kernel version is like "6.14.5", need VERSION=6, PATCHLEVEL=14, SUBLEVEL=5
    export VERSION=$(echo "${kernel.modDirVersion}" | cut -d. -f1)
    export PATCHLEVEL=$(echo "${kernel.modDirVersion}" | cut -d. -f2)
    export SUBLEVEL=$(echo "${kernel.modDirVersion}" | cut -d. -f3)
    
    # Check if we have the right paths and versions
    echo "Kernel version: $KERNELRELEASE"
    echo "Parsed VERSION=$VERSION PATCHLEVEL=$PATCHLEVEL SUBLEVEL=$SUBLEVEL"
    echo "Kernel dir: $KERNEL_DIR"
    echo "Kernel source exists: $(test -d $KERNEL_DIR && echo yes || echo no)"
    
    # Make sure we're building for the right architecture
    export ARCH="x86_64"
  '';

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
    "VERSION=$(echo ${kernel.modDirVersion} | cut -d. -f1)"
    "PATCHLEVEL=$(echo ${kernel.modDirVersion} | cut -d. -f2)" 
    "SUBLEVEL=$(echo ${kernel.modDirVersion} | cut -d. -f3)"
  ];

  # Custom build phase to handle the driver compilation properly
  buildPhase = ''
    runHook preBuild
    
    # Run make with verbose output to see what's happening
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD modules \
      KERNELRELEASE=${kernel.modDirVersion} \
      KVER=${kernel.modDirVersion} \
      V=1
      
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    # Create the output directory structure
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/usb
    
    # Copy the compiled module
    cp r8152.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/usb/
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Realtek r8152 USB Ethernet driver (out-of-tree)";
    homepage = "https://github.com/wget/realtek-r8152-linux";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
