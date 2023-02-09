#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="opentomb"
rp_module_desc="opentomb - Tomb Raider (1 - 5)"
rp_module_licence="GPL3 https://raw.githubusercontent.com/opentomb/OpenTomb/master/LICENSE"
rp_module_section="exp"
rp_module_flags=""

function depends_opentomb() {
    # For RPi may need libpng12-dev
    getDepends libopenal-dev libsdl2-dev libpng-dev libglu1-mesa-dev zlib1g-dev

}

function sources_opentomb() {
    gitPullOrClone "$md_build" https://github.com/opentomb/OpenTomb.git
}

function build_opentomb() {
    mkdir build
    cd build
    cmake ..
    make clean
    make
}

function install_opentomb() {
    md_ret_files=(
        "build/OpenTomb"
    )
}

function configure_opentomb() {
    local launcher=("$md_inst/OpenTomb")

    for x in 1 2 3 4 5; do
        mkRomDir "ports/tombraider${x}"
        moveConfigDir "${md_inst}/data/tr${x}" "${romdir}/ports/tombraider${x}"
        moveConfigDir "${md_inst}/data/tr${x}_gold" "${romdir}/ports/tombraider${x}"
        addPort "$md_id" "tombraider${x}" "Tomb Raider ${x}" "${launcher[*]}"
    done

}
