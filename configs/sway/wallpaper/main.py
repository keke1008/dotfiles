#!/usr/bin/env python

"""
Voronoi-based wallpaper generator
Produces a matte, mosaic-like background using Voronoi cell decomposition.
Colors are constrained to blue-dominant tones (R <= B and G <= B).
"""

import sys

import numpy as np
from PIL import Image
from scipy.spatial import cKDTree

# --- Settings ---
WIDTH, HEIGHT = 3840, 2160  # Output resolution
NUM_CELLS = 3200  # Number of Voronoi cells (more = finer mosaic)
BASE_COLOR = (0x15, 0x16, 0x1B)  # Base color (#15161B)
SEED = 42  # Random seed for reproducibility

# Color variation ranges per channel (relative to BASE_COLOR)
R_RANGE = (-4, 6)
G_RANGE = (-4, 6)
B_RANGE = (-4, 30)  # Blue channel has wider range for blue-tinted look

# Vignette strength (0.0 = none, higher = darker edges)
VIGNETTE_STRENGTH = 0.12
VIGNETTE_MAX = 0.18


def gen() -> Image.Image:
    rng = np.random.default_rng(SEED)
    base = np.array(BASE_COLOR, dtype=np.float32)

    # Step 1: Scatter random seed points across the canvas
    points = rng.random((NUM_CELLS, 2)) * [WIDTH, HEIGHT]

    # Step 2: Assign a random color to each cell
    R = base[0] + rng.uniform(*R_RANGE, NUM_CELLS)
    G = base[1] + rng.uniform(*G_RANGE, NUM_CELLS)
    B = base[2] + rng.uniform(*B_RANGE, NUM_CELLS)

    # Enforce blue dominance: R <= B and G <= B
    R = np.minimum(R, B)
    G = np.minimum(G, B)

    cell_colors = np.stack([R, G, B], axis=1).clip(0, 255)

    # Step 3: Build a pixel grid and find the nearest seed point for each pixel
    xs = np.arange(WIDTH, dtype=np.float32)
    ys = np.arange(HEIGHT, dtype=np.float32)
    gx, gy = np.meshgrid(xs, ys)
    grid = np.stack([gx.ravel(), gy.ravel()], axis=1)

    tree = cKDTree(points)
    _, idx = tree.query(grid, workers=-1)  # idx[i] = index of nearest seed for pixel i

    # Step 4: Paint each pixel with its cell's color
    img = cell_colors[idx].reshape(HEIGHT, WIDTH, 3).astype(np.uint8)

    # Step 5: Apply a subtle radial vignette (darken edges)
    cx, cy = WIDTH / 2, HEIGHT / 2
    dist = np.sqrt(((gx - cx) / cx) ** 2 + ((gy - cy) / cy) ** 2)
    vignette = (1.0 - np.clip(dist * VIGNETTE_STRENGTH, 0, VIGNETTE_MAX)).reshape(
        HEIGHT, WIDTH, 1
    )
    img = (img * vignette).clip(0, 255).astype(np.uint8)

    return Image.fromarray(img)


OUTPUT_PATH = "wallpaper_voronoi.png"


def save(img: Image.Image):
    assert len(sys.argv) == 2
    output_path = sys.argv[1]

    img.save(output_path)


if __name__ == "__main__":
    img = gen()
    save(img)
