from __future__ import annotations

from collections.abc import Sequence

try:
    import matplotlib.pyplot as plt
    from matplotlib.animation import FuncAnimation
    from matplotlib.patches import Rectangle
except ImportError:
    plt = None
    FuncAnimation = None
    Rectangle = None

from escape.grid import Coordinate, GridProblem

def check_path(problem: GridProblem, path: Sequence[Coordinate] | None) -> None:
    """ Check a path. """
    if not isinstance(path, list):
        print("Path not valid: should be a list.")
        return

    if len(path) == 0:
        print("Path not valid: should be of length at least 1.")
        return

    if path[0] != problem.start:
        print("Path not valid: should start at the initial position of the robot.")
        return
    
    if path[-1] != problem.goal:
        print("Path not valid: should end at the goal.")
        return

    for i, position in enumerate(path):
        if not isinstance(position, tuple) or len(position) != 2:
            print("Path not valid: should be a list of coordinates.")
            return 

        x, y = position

        if not isinstance(x, int) or not isinstance(y, int):
            print("Path not valid: coordinate should be integers.")
            return False

        if x < 0 or x >= problem.width or y < 0 or y >= problem.height:
            print(f"Path not valid: coordinate ({x}, {y}) at k = {i} outside the grid.")
            return
        
        if (x, y) in problem.obstacles:
            print(f"Path not valid: coordinate ({x}, {y}) at k = {i} reaches an obstacle.")
            return

    for i in range(len(path) - 1):
        x1, y1 = path[i]
        x2, y2 = path[i + 1]

        distance = abs(x2 - x1) + abs(y2 - y1)

        if distance != 1:
            print(f"Path not valid: illegal movement between k = {i} and {i+1} (({x1}, {y1}) -> (({x2}, {y2})).")
            return

    print("Path validated.")  
    
def _draw_grid_base(ax, problem: GridProblem) -> None:
    ax.set_title(problem.name)
    ax.set_xlim(0, problem.width)
    ax.set_ylim(0, problem.height)
    ax.set_aspect("equal")
    ax.set_xticks(range(problem.width + 1))
    ax.set_yticks(range(problem.height + 1))
    ax.grid(True)
    ax.set_xlabel("x")
    ax.set_ylabel("y")

    for x, y in problem.obstacles:
        ax.add_patch(Rectangle((x, y), 1, 1, hatch="///", alpha=0.4))

    sx, sy = problem.start
    gx, gy = problem.goal
    ax.text(sx + 0.5, sy + 0.5, "S", ha="center", va="center", fontsize=16, fontweight="bold")
    ax.text(gx + 0.5, gy + 0.5, "G", ha="center", va="center", fontsize=16, fontweight="bold")

def animate_path(problem: GridProblem, path: Sequence[Coordinate] | None) -> None:
    """Animate the witness path."""
    if plt is None:
        print()
        print("Error: matplotlib not installed. Cannot use --viz option.")
        return

    fig, ax = plt.subplots()
    _draw_grid_base(ax, problem)

    if not path:
        plt.show()
        return

    line, = ax.plot([], [], marker="o")
    robot, = ax.plot([], [], marker="s", markersize=14)
    step_label = ax.text(0.02, 1.02, "", transform=ax.transAxes)

    def update(frame: int):
        prefix = path[: frame + 1]
        xs = [x + 0.5 for x, _ in prefix]
        ys = [y + 0.5 for _, y in prefix]
        line.set_data(xs, ys)
        robot.set_data([xs[-1]], [ys[-1]])
        step_label.set_text(f"step {frame}/{len(path) - 1}: {path[frame]}")
        return line, robot, step_label

    animation = FuncAnimation(fig, update, frames=len(path), interval=650, repeat=False)
    fig._bmc_grid_animation = animation
    plt.show()
