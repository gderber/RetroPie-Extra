#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
# This game works on i386, arm64, and amd64 package architectures
#
rp_module_id="ut"
rp_module_desc="Unreal Tournament"
rp_module_licence="PROP https://github.com/OldUnreal/UnrealTournamentPatches/blob/master/LICENSE.md"
rp_module_help=""
rp_module_section="exp"
rp_module_repo="https://github.com/OldUnreal/UnrealTournamentPatches/"
rp_module_flags="!all x86 64bit"

# function depends_ut() {
#     local depends="libsdl2-2.0-0 libopenal1"
#     getDepends "${depends[@]}"
# }

function install_bin_ut() {
    local version="469d"
    local arch="$(dpkg --print-architecture)"

    # The download files use "x86" for the i386 architecture
    [[ "${arch}" == "i386" ]] && arch="x86"

    local dl_file="OldUnreal-UTPatch${version}-Linux-${arch}.tar.bz2"

    # For some reason, it failed when using "$rp_module_repo", this works perfectly.
    local base_url="https://github.com/OldUnreal/UnrealTournamentPatches"
    local dl_url="${base_url}/releases/download/v${version}/${dl_file}"
    downloadAndExtract "$dl_url" "$md_inst"
}

function __config_texture_dir() {
    if [[ ! -d "$romdir/ports/ut/Textures" ]]; then
       mkdir -p "$romdir/ports/ut/Textures"
    fi

    if [[ -d "$md_inst/Textures" ]]; then
        for file in LadderFonts.utx UWindowFonts.utx; do
            mv -u "$md_inst/Textures/$file" "$romdir/ports/ut/Textures/$file"
        done

        rm -rf "$md_inst/Textures"
        ln -snf "$romdir/ports/ut/Textures" "$md_inst/Textures"
    fi

}

function configure_ut() {
    addPort "$md_id" "ut" "Unreal Tournament" "$md_inst/System64/ut-bin"
    mkRomDir "ports/ut"

    echo "Configure UT"

    if [[ "$md_mode" == "install" ]]; then
        __config_texture_dir

        # link game data to install dir
        for dir in Maps Music Sounds; do
            ln -snf "$romdir/ports/ut/$dir" "$md_inst/$dir"
        done

        for file in skeletalchars.int SkeletalChars.u; do
            ln -snf "$romdir/ports/ut/System/$file" "$md_inst/System/$file"
        done
    fi
    moveConfigDir "$home/.utpg" "$md_conf_root/ut"
}
