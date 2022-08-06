# AltAddonSystem PSP Update
New mission.lvl has stubs added (see AltAddon_GenerateStubs.ps1 to generate new stubs) numbered 000c_con and 000g_con through to 064c_con and 064g_con (this is arbitrary). These stubs don't contain any LUA scripting besides pointing the LUA environment to search for, read in, and execute actual script files (compiled .lua files named XXXy_con_actual.script) located in the respective _lvl_psp/addon/xxx folders. 

This allows end users to add new map addons to their unpacked PSP SWBF2 game without requiring a Windows PC to execute MissionMerge.exe.

## Initial setup (method 1):
1. Place the 'addon' folder under the '_LVL_platform' (PS2|PSP|XBOX) folder for the game you want to mod.
1. Run the 'initial_setup_PS2.bat', 'initial_setup_PSP.bat' or 'initial_setup_XBOX.bat' file.
1. Move the 'initial_setup_'.bat' files to the 'addon\\bin\\' folder (to de-clutter the 'addon' folder).


Adding a mod (method 1):
1. Drop the mod in the addon folder (a folder from '001' - '999' )
1. Double-Click the 'click_to_merge.bat' program (in the addon folder )
1. Deploy to device (if necessary)

<details> <summary># ORIGINAL README</summary>
An Alternate addon system for SWBF (2004) and SWBFII (2005).
Useful for the console versions of the games (but could be used on the PC files also).

Evolved from 'https://github.com/BAD-AL/SWBFII_Alt_Addon_System'

It is meant to be a 'Drop and Click' process (after initial setup).

## Initial setup:
1. Place the 'addon' folder under the '_LVL_platform' (PS2|PSP|XBOX) folder for the game you want to mod.
1. Run the 'initial_setup_PS2.bat', 'initial_setup_PSP.bat' or 'initial_setup_XBOX.bat' file.
1. Move the 'initial_setup_'.bat' files to the 'addon\\bin\\' folder (to de-clutter the 'addon' folder).


Adding a mod:
1. Drop the mod in the addon folder (a folder from '001' - '999' )
1. Double-Click the 'click_to_merge.bat' program (in the addon folder )
1. Deploy to device (if necessary)

## Videos (YouTube)
* [Porting XBOX Addon to Alt Addon System and DLC package](https://youtu.be/LVhKMDW22AY)
* [Alt Addon system with AnthonyBF2's PSP mod](https://youtu.be/HyGFpVQ9VHQ)

</details>	

<details> <summary>More info for modders</summary>

### This addon system does the following:
* Updates 'mission.lvl' to include the 'alternate addon' missions (folders '000-999').
* Updates 'core.lvl' to contain the strings from the 'alternate addon' mods (folders '000-999').

### This addon system enables the following:
* Easy overriding of scripts used in shell.lvl and ingame.lvl.
* Loading of more resources/files for shell.lvl and ingame.lvl.
  * see the addon\\000\\_WORKSPACE_\\ folder for more details.
  * Note: 'ingame' only applicable to SWBFII (2005)

</details>	
