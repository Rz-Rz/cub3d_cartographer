# cub3d_cartographer
The cartographer contains two features : a map generation script and a map parsing tester.
# Map Generation Script
This script is a utility for generating a map with customizable size and iteration count. It can also select textures randomly from .xpm files in a provided directory, and generate random RGB colors. The script offers flexible usage modes, allowing you to generate the map, textures, colors, or all at once.
### Installation
1. Ensure you have Python 3.6 or above installed.
2. Download or clone this repository to your local machine. If you have Git installed, you can clone it using the following command: 
```bash
git clone git@github.com:Rz-Rz/cub3d_cartographer.git
```
3. Navigate to the directory of the script:
```bash
cd cub3d_cartographer
```

### Usage
The script can be run from the command line with several options:

-**-w, --width**: Specify the width of the map (default is 20).
-**-ht, --height**: Specify the height of the map (default is 20).
-**-i, --iterations**: Specify the number of iterations for map generation (default is 500).
-**-p, --path**: Path to the directory with .xpm files for texture selection. This is a required argument.
-**-m, --mode**: Mode of operation. Can be 'map', 'texture', 'color', or 'all' (default is 'all').

Here's an example of how to use the script:

```bash
python map_gen.py -w 30 -H 30 -i 1000 -p /path/to/your/xpm/files -m all
```

This command generates a map of size 30x30 with 1000 iterations, selects textures from the provided directory, and generates random RGB colors.

### Modes
- **map**: Generate and print a map.
- **texture**: Select four random .xpm files from the provided directory and print their paths.
- **color**: Generate six sets of random RGB colors and print them.
- **all**: Perform all of the above actions.

### Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

