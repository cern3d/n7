from __future__ import annotations

import argparse

from escape.grid import load_grid
from escape.manipulate import animate_path, check_path
from escape.solver import solve

def main():
    parser = argparse.ArgumentParser(description="Robot Escape")
    parser.add_argument("--grid", required=True, help="Path to a grid JSON file")
    parser.add_argument("--max-bound", type=int, default=20, help="Maximum BMC bound")
    parser.add_argument("--viz", action="store_true", help="Visualization")
    args = parser.parse_args()

    if args.max_bound < 0:
        parser.error("--max-bound must be non-negative")

    problem = load_grid(args.grid)

    print(f"Loaded grid: {problem.name}")
    print(f"size: {problem.width} x {problem.height}")
    print(f"start: {problem.start}")
    print(f"goal:  {problem.goal}")
    print(f"obstacles: {sorted(problem.obstacles)}")
    print()

    try:
        result = solve(problem, args.max_bound)
    except NotImplementedError as exc:
        print()
        print("The student skeleton is incomplete.")
        print(exc)
        return

    print()

    if result is None:
        print(f"No path found up to bound {args.max_bound}.")
    else:
        print(f"Path found")
        for t, cell in enumerate(result):
            print(f"  t = {t:2d}: {cell}")
        
        print()
        check_path(problem, result)

    if args.viz:
        animate_path(problem, result)
