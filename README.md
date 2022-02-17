# Teamkill Maps

Godot Project file including templates and assets needed to import maps & music into Teamkill
------
In this package, you should find a Godot (3.4.2) project, bundled together with the amazing addon [Qodot](https://github.com/QodotPlugin/qodot-plugin) (an addon that allows for importing Quake .map files)

To use it, you'll need to download Godot, which you can get here. It's currently running on 3.4.2, but it shouldn't be too important if you have a recent version.
https://godotengine.org/download/windows

You might also want to pick up a mapping tool that can make Quake maps, like Trenchbroom: https://trenchbroom.github.io

If you're new to Godot Engine, I would highly recommend learning a bit about the engine first! The documentation is pretty solid https://docs.godotengine.org/en/stable/index.html

They've also compiled a list of tutorials & resources/tools/etc to help you get into the swing of it https://docs.godotengine.org/en/stable/community/tutorials.html

And if you're unfamiliar with Qodot I can also highly recommend checking their [Github page](https://github.com/QodotPlugin/qodot-plugin) and their [wiki page](https://qodotplugin.github.io) for more information. It also comes bundled with some example scenes in `addons/qodot/example_scenes`, covering a wide range of subjects.

------

### TRENCHBROOM INFO/SETUP:
Bundled with this you should find a .zip containing config files used for Trenchbroom, the folder inside the zip should be put into trenchbroom/games, and should look like `"X:/blahblah/YourTrenchbroomFolder/games/Teamkill"`. Alternatively, you can generate one from within the project itself using Qodot.

To setup Trenchbroom with it, open Trenchbroom, create a new map, it should show a list of games, if Teamkill is listed, congrats!!
In "Game Path", give it the path to your TK-Maps project folder, ex: `C:/EpicGaming/Maptools/Teamkill-Maps`

You should now have access to a few entities in the "Entity" tab, as well as all the textures you've added to your project folder.

Entity info:
"Player" - player spawn points. Currently in the game, the first spawn is always randomized, so the order will always  be somewhat random. Has a "rotation" parameter so you can in the spawn's rotation in Godot measurements as a Vector3 (x,y,z)
"light" - Adds a light source to the map, check Qodot & Trenchbroom documentation for how to set options for it
"receiver" & "signal" - entities related to Godot's signal system, for more info on how to use these check out Qodot's example scenes & wiki page
"Respawn" - a brush tag that allows you to set an area that will forcefully move a player to a random spawnpoint when touched

------

# MAPS

## GETTING STARTED
After opening Godot and loading the project (importing everything may take a while..), in the `FileSystem` window, you should see a few folders, the important ones for now are
- `Maps` - This is where your maps have to be located when exporting your files, or else it won't work ingame. There's also an example map provided here.
- `Music` - The folder containing music assets and MusicPacks (needed for custom music in game), I'd recommend dumping any raw assets in `Music/Raw/Dynamic/YourSongHere`. MusicPack resource files must be in `Music/MusicPacks` to be usable ingame
- `Templates` - A folder containing some template/example files split into subfolders by category
- `TOOLS` - A folder containing a MusicPreview tool to help you test any custom music packs without having to import into the game first (maybe more tools in the future who knows, don't worry about "exporter" it sucks :) )
- `textures` - The folder containing game textures, Trenchbroom and the map template look for textures in this folder, so when importing your own textures, you will have to add them here!
- `Objects` - Folder containing game objects like a launch pad, teleporter, powerups, etc. 



## IMPORTING YOUR MAP FROM TRENCHBROOM TO GODOT
In `Templates/Maps` you should see a `MapTemplate.tscn` (in `map_scene_templates`) and a `MapFile.tres`, the MapTemplate is the "level" and the MapFile resource handles metadata like map author, map name and max players.

To get your map imported into Godot, I'd recommend making a copy of the `MapTemplate.tscn` and moving this to `Maps/YourNewMapFolder/YourMap.tscn`. Then load your new scene.

Your Scene view should look something like this:

![image](https://user-images.githubusercontent.com/63461061/154527314-ec2e2542-3109-488f-a5c6-67c34ec6cece.png)

- "Map" holds information about allowed music tracks on this map, whether or not to use dynamically recolorable surfaces (currently only used for the VR grid textures) - See the SkylinesVR example map for usage
- "Environment" is the node that contains your actual level, by default a QodotMap node.
- "SpawnPoints" is the node the game will look for your map's spawn points in, you will need to keep them in this node for them to be understood by the game.
- "Pickups" - A node made for organizing any pickups, it's just a structure thing, not important.
- "Cameras" - The game will look for the Camera node from here to show while loading/etc.


For now, click on `Environment`, in the Inspector view you will see a `Map File` field, this is where you select your `.map` file from Trenchbroom/your tool of choice.

![image](https://user-images.githubusercontent.com/63461061/154529100-5e2e7631-0569-4b9b-be2a-97e4e2eaa0fb.png)


When this is done, click "Full Build" in the toolbar at the top, and Qodot should start working its magic!

![image](https://user-images.githubusercontent.com/63461061/154529187-9821be11-cdb0-4ff2-99ce-1c404ab9fa3e.png)


If you assigned any spawn points in Trenchbroom, make sure to move them out of `Environment` and into `SpawnPoints`. You will be able to tell them apart as Position3D nodes/this icon ![image](https://user-images.githubusercontent.com/63461061/154530804-3d8a61df-7912-4196-a9f5-a7a032efb2a7.png)

From here, make any changes you want to your map and save when you're done.


## GETTING YOUR MAP INTO TEAMKILL

Once you've got your map scene ready to go, head back to `Templates/Maps` and make a copy of the `MapFile.tres`, move this to the root of `Maps`.  Double click it and fill out the information as necessary, `Max Players` being the most important.

![image](https://user-images.githubusercontent.com/63461061/154531509-2c42f325-beb2-43d2-a677-4ea1360030b1.png)

Once this is done, use Godot's built-in export feature, and export as a `.pck` file, and make sure the map scene (`.tscn`), the map file resource (`.tres`) and any custom assets you may have included for the map - textures should automatically be handled for you regardless.


------
## UPLOADING TO STEAM WORKSHOP

In the Teamkill game itself, there's a button in the lower right corner that will take you to a tool allowing you to upload to Workshop
![image](https://user-images.githubusercontent.com/63461061/154531903-a6cbd402-2496-4c95-b48d-84a4231dc1f5.png)

It should look like this:

![image](https://user-images.githubusercontent.com/63461061/154532520-8d6a37f3-3e1b-49e8-9aea-122563100ee7.png)

To upload your item to the workshop:
- If you're creating a new item: click **Create Workshop Item**
- If you're updating an existing item: **copy the ID from the Steam Workshop page into the "Workshop item ID" field**, then click **Update Existing Item**

Fill out the title, description, item visibility, content folder and item thumbnail fields, and the **Submit Update** should become clickable. Changelog is optional.

(This may be slightly finicky, try adding/removing a letter from a text field if it seems to be "stuck", and it should work.)

### NOTE:
The content folder has to be a folder containing your `.pck`, all files in this folder will be included as part of your Steam Workshop upload

