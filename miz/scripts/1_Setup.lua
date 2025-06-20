G_AETHER = AETHR:New():Init()

G_AETHER.fileOps.saveTableAsJSON(
    G_AETHER.STORAGE.PATHS.CONFIG_FOLDER,
    "AETHR_Config.json",
    {
        version = G_AETHER.VERSION,
        author = G_AETHER.AUTHOR,
        github = G_AETHER.GITHUB,
        description = G_AETHER.DESCRIPTION,
        storage = G_AETHER.STORAGE.PATHS
    }
)