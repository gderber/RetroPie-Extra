
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="xlava_jo"
rp_module_desc="xlava_jo - xLava: Jedi Outcast (SP + MP)"
rp_module_licence="GPL2 https://raw.githubusercontent.com/xLAva/JediOutcastLinux/JediOutcastLinux/LICENSE.txt"
rp_module_help="Copy assets0.pk3  assets1.pk3  assets2.pk3  assets3.pk3 into $romdir/jedioutcast/"
rp_module_section="exp"
rp_module_flags="!all x86"

function _arch_xlava_jo() {
    # exact parsing from Makefile
    echo "$(uname -m | sed -e 's/i.86/x86/' | sed -e 's/^arm.*/arm/')"
}

function depends_xlava_jo() {
    # lis build currenntly fails without libsdl2-dev:i386
    #
    # libsdl2-dev:i386 depends on libmirclient-dev:i386 which conflicts with libmirclient-dev:amd64
    #
    # On hold because of dependency errors, requirement for x86 32bit, single player only, and openjk_jo works

    getDepends build-essential cmake libsdl2-dev:i386 libglm-dev libopenal-dev:i386 g++-multilib

}

function sources_xlava_jo() {
    gitPullOrClone "$md_build" https://github.com/xLava/JediOutcastLinux.git
}

function build_xlava_jo() {
    mkdir "$md_build/build"
    cd "$md_build/build"
    cmake -DCMAKE_INSTALL_PREFIX="$md_inst" ..
    make clean
    make

    md_ret_require="$md_build/build/openjk_sp.$(_arch_xlava_jo)"
}

function install_xlava_jo() {
    md_ret_files=(
        "build/jk2gamex86.so"
        "build/jk2sp"
    )
}

function configure_xlava_jo() {
    addPort "xlava_jo" "jedioutcast_sp" "Star Wars - Jedi Knight - Jedi Outcast (SP)" "$md_inst/jk2sp"
    addPort "xlava_jo" "jedioutcast_mp" "Star Wars - Jedi Knight - Jedi Outcast (MP)" "$md_inst/openjk.$(_arch_xlava_jo)"

    mkRomDir "ports/jediacademy"

    moveConfigDir "$md_inst/base" "$romdir/ports/jediacademy"
}
