inherit icemake kyuba-org-git

DESCRIPTION="udev/devfs workalike, based on Duat"

SLOT="0"
DEPEND="${DEPEND}
    >=sys-libs/curie-7
    >=sys-libs/duat-5"

ICEMAKE_PREFIX="/"
