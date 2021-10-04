# Teamkill-Maps
Mapping project file to assist in making maps for Teamkill
------
TK Mapping tools! - Now slightly less janky!

In this package, you should find a Godot project (made with Godot 3.3.4 in mind)

To use it, you'll need to download Godot, which you can get here. It's currently running on 3.3.4, but it shouldn't be too important if you have a recent version.
https://godotengine.org/download/windows

You might also want to pick up a mapping tool that can make Quake maps, like Trenchbroom: https://trenchbroom.github.io

If you're new to Godot Engine, the documentation is pretty solid! https://docs.godotengine.org/en/stable/index.html
They've also compiled a list of tutorials & resources/tools/etc to help you get into the swing of it https://docs.godotengine.org/en/stable/community/tutorials.html

And if you're unfamiliar with Qodot (an addon that allows for importing Quake .map files) you can find a brief description here: https://github.com/QodotPlugin/qodot-plugin alongside their wiki on how to use it: https://qodotplugin.github.io. It also comes bundled with some examples in qodot/example_scenes, covering a wide range of subjects.

------

# TRENCHBROOM INFO/SETUP:
Bundled with this you should find a .zip containing config files used for Trenchbroom, the folder inside the zip should be put into trenchbroom/games, and should look like "X:/blahblah/trenchbroom/games/Teamkill 0.0.8"

To setup Trenchbroom with it, open Trenchbroom, create a new map, it should show a list of games, if Teamkill is listed, congrats!!
In "Game Path", give it the path to your TK-Maps project folder, ex: C:/EpicGaming/Maptools/Teamkill-Maps.

You should now have access to a few entities in the "Entity" tab, as well as all the textures you've added to your project folder.

Entity info:
"Player" - player spawn points. Currently in the game, the first spawn is always randomized, so the order will always  be somewhat random. Has a "rotation" parameter so you can in the spawn's rotation in Godot measurements as a Vector3 (x,y,z)
"light" - Adds a light source to the map, check Qodot & Trenchbroom documentation for how to set options for it
"receiver" & "signal" - entities related to Godot's signal system, for more info on how to use these check out Qodot's example scenes & wiki page


------

# PROJECT INFO:
All game textures go in the "textures" folder, ideally in a subfolder, currently included are all the textures currently in the build plus a mini-set of example images that are exclusive to the mapping setup ("custom_example")

I also have a very janky and hastily put together tool to help you get your custom textures into the game, in form of the "exporter" tool in the Godot project!

To use it:

If not already opened, double-click "exporter.tscn" in your FileSystem view (but it should happen by default), then click on the "exporter" node in the Scene view
On the Inspector view on the right, you'll have a few options:

File Name - give your exported file a name
Texture Path - Select the folder you used for your custom textures
Create File (on/off button) - clicking this should start the packing, but this is currently a bit jank. If the checkmark stays on forever or the output  console at the bottom seemingly does nothing, close the exporter.tscn scene and reopen it, and it should eventually behave. --  It'll be improved soon enough :)

Exported files can be found in "exports" folder, and you should be able to plop this .pck file right into your "textures" folder in Teamkill, alongside your .map file you've made in Trenchbroom