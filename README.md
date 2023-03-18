# MCDatTab
LEVELS.DAT/TAB file creator for Bullfrog's Magic Carpet game.

This script can concatenate Magic Carpet LEV000XX.DAT level files into the needed LEVELS.DAT and LEVELS.TAB files to run them in game. This is necessary if you want to edit, re-order, or add more levels to the game in order to actually play them.
To get at the level files you must own the original release of Magic Carpet (NOT Magic Carpet Plus), where you will find them in the LEVELS directory on the CD. 
The script expects to find the level files LEV00000.DAT to LEV00069.DAT in the folder or path it is run from. It will then join them together into LEVELS.DAT and create the accompanying LEVELS.TAB file.
With this tool you can now edit the levels with a hex editor, and recompile them again to play them.

# Usage:
The script takes no arguments, just run it in the directory with ALL level.dat files present as described above. It will overwrite any previous LEVELS.DAT and LEVELS.TAB files present.

# Workflow:
1. Copy files from Magic Carpet game CD somewhere to work on
2. Unpack the level file you want to work on using e.g. [this tool](https://github.com/lab313ru/rnc_propack_source)
3. Edit the level file to your liking with your hex editor of choice (see [this repository](https://github.com/michaelhoward/MagicCarpetFileFormat) for level file format).
4. Recompress the file using RNC
5. Run this script in the directory with all level files
6. Copy the created LEVELS.DAT and LEVELS.TAB files to your CARPET.CD\LEVELS directory wherever the game is installed.
7. **Write protect the LEVELS.DAT and LEVELS.TAB files!** This is because the game copies a fresh copy of these files from the CD to the hard drive each time it is run, destroying your hard work!
8. Play and enjoy

# Notes
Bullfrog used the .DAT/TAB format for storing images in games - this script cannot create those kinds of files, they store image data (size etc) this script doesn't know about. This script can only produce the ultra simple format used for binaries as per the LEVELS.DAT/TAB files used by Magic Carpet. It's likely other games of theirs used this format and this script can easily be adapted for them too. 
The script assumes you will always be merging the 70 final game levels together and nothing else. You can change this behaviour by editing the DO/UNTIL loops for a higher count (e.g. if you are adding a new level, then change them to end and start on 71 instead of 70). The file format supports 1000 levels, I don't know if the game actually supports this many.

File format details: .DAT files start with a basic header reading BULLFROG. Strictly speaking I don't think this is actually needed (the later demo doesn't use it and clearly works in the same way), but it's included just for completeness. Then all the RNC compressed levelXX.DAT files are concatenated together in order. 
The .TAB file is very simple, it just contains the start byte of each constituent file of the .DAT file. All in all there are 4 bytes reserved for each file, and a total of 1000 "slots" for files. The first entry is always byte 8 because that is the end of the BULLFROG header. Notably the second demo of the game doesn't use this and starts at byte 0, so not having the header seems entirely possible. Once the final file location is written, the rest of the slots are simply filled with the same final entry repeated until EOF. 
