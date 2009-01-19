inherit icemake kyuba-org

DESCRIPTION="udev/devfs workalike, based on Duat"

SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
DEPEND="${DEPEND}
    >=sys-libs/curie-6
    >=sys-libs/duat-4"

ICEMAKE_PREFIX="/"
