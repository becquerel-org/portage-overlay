IUSE="doc debug combine"

DEPEND="${DEPEND}
        >=sys-devel/icemake-6
        doc? ( app-doc/doxygen )"

ICEMAKE_TARGETS=""
ICEMAKE_PREFIX="/usr"

EXPORT_FUNCTIONS src_compile src_test src_install

icemake_flags() {
    local icemake_params=""

    if use debug; then
        icemake_params="${icemake_params} -D"
    fi

    if use combine; then
        icemake_params="${icemake_params} -c"
    fi

    echo ${icemake_params}
}

icemake_src_compile() {
    icemake ${ICEMAKE_TARGETS} $(icemake_flags) -Ld "${D}${ICEMAKE_PREFIX}"||die

    if use doc; then
        doxygen
    fi
}

icemake_src_test() {
    icemake ${ICEMAKE_TARGETS} $(icemake_flags) -Ldr "${D}${ICEMAKE_PREFIX}"||die
}

icemake_src_install() {
    icemake ${ICEMAKE_TARGETS} $(icemake_flags) -Ldif "${D}${ICEMAKE_PREFIX}"||die

    dodoc AUTHORS COPYING CREDITS README

    if use doc; then
        for i in documentation/doxygen/man/*/*; do
            doman ${i}
        done
    fi
}
