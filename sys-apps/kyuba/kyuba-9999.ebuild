inherit icemake kyuba-org-git

DESCRIPTION="The Kyuba Init Daemons"
EGIT_REPO_URI="git://git.kyuba.org/core.git"

SLOT="0"
DEPEND="${DEPEND}
    >=sys-libs/curie-7
    >=sys-libs/duat-5"

ICEMAKE_PREFIX="/"
ICEMAKE_ALTERNATE_FHS="kyu"
