import random
import argparse
import os
import glob

def create_map(width, height):
    return [['1' for _ in range(width)] for _ in range(height)]

def is_valid_move(x, y, width, height):
    return x > 0 and x < width - 1 and y > 0 and y < height - 1

def generate_map(width, height, iterations):
    map = create_map(width, height)

    x, y = width // 2, height // 2
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    for _ in range(iterations):
        dx, dy = random.choice(directions)
        if is_valid_move(x + dx, y + dy, width, height):
            x += dx
            y += dy
            map[y][x] = '0'

    map[y][x] = 'N'
    return map

def print_map(map):
    for row in map:
        print(''.join(row))

def select_xpm_files(path):
    xpm_files = glob.glob(os.path.join(path, '*.xpm'))
    return random.sample(xpm_files, 4) if len(xpm_files) > 4 else []

def generate_rgb():
    return [random.randint(0, 255) for _ in range(3)]

def main(width, height, iterations, path, mode):
    if mode in ['texture', 'all']:
        xpm_files = select_xpm_files(path)
        if len(xpm_files) == 4:
            print(f"NO {xpm_files[0]}")
            print(f"SO {xpm_files[1]}")
            print(f"EA {xpm_files[2]}")
            print(f"WE {xpm_files[3]}")
        else:
            print("Not enough .xpm files in the provided directory")
    if mode in ['color', 'all']:
        rgb = generate_rgb()
        print(f"F {rgb[0]},{rgb[1]},{rgb[2]}")
        rgb = generate_rgb()
        print(f"C {rgb[0]},{rgb[1]},{rgb[2]}")
        print("\n");
    if mode in ['map', 'all']:
        map = generate_map(width, height, iterations)
        print_map(map)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate a map')
    parser.add_argument('-w', '--width', type=int, default=20, help='Width of the map')
    parser.add_argument('-ht', '--height', type=int, default=20, help='Height of the map')
    parser.add_argument('-i', '--iterations', type=int, default=1000, help='Number of iterations')
    parser.add_argument('-p', '--path', type=str, default=".", help='Path to the .xpm files')
    parser.add_argument('-m', '--mode', type=str, default='all', choices=['map', 'texture', 'color', 'all'], help='Mode of operation')
    args = parser.parse_args()
    main(args.width, args.height, args.iterations, args.path, args.mode)
