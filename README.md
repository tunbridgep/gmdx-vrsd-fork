# GMDX: Augmented Edition #
This mod makes extensive changes to Deus Ex's gameplay in order to improve balance, increase depth, add difficulty, and improve the experience overall.

GMDX: AE also has a significant focus on quality of life features, playability, and modernisation, without undermining the core gameplay.

The mod can be downloaded from [ModDB](https://www.moddb.com/mods/give-me-deus-ex-augmented-edition) or [Nexusmods](https://www.nexusmods.com/deusex/mods/85)

## Building and Contributing ##

Pull requests are welcome!

Most Deus Ex modding guides recommend decompiling the source from .u files, however this is not a good solution.

To build, simply clone the project, then symlink the `src/_Classes/DeusEx` and `src/_Classes/RSDCrap` folders to your `Games/Deus Ex/` folder.
This can be done easily using [Link Shell Extension](https://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html)

Make sure the [Deus Ex SDK](https://www.moddb.com/games/deus-ex/downloads/sdk-v1112fm) is installed, then delete DeusEx.u and RSDCrap.u in your `Games/Deus Ex/System` folder and it should rebuild them.

For a more detailed guide to editing the mod, please see `Docs/GMDX AE Users Manual.txt`

All contributions should be submitted via pull requests. Please document changes in `Docs/GMDX AE Changelog.txt` as they are added.

For more information, please join the mods [discord server](https://discord.gg/zv8egePsAu)

This mod is based off [GMDX vRSD](https://www.moddb.com/mods/gmdx/addons/version-rsd-beta-10-future-official-update) which is itself based on [GMDX v9](https://www.moddb.com/mods/gmdx/addons/deusex-gmdx903-persistence-mod).

Please note that the original mod versions used their own licensing terms (attribution required, etc), but I have open-sourced this version of the mod with their permission.
If you wish to make changes to GMDX v9 or GMDX vRSD directly, please contact Totalitarian or RoSoDude for permission.
