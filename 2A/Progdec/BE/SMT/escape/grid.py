from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
from typing import Iterable


Coordinate = tuple[int, int]


@dataclass(frozen=True)
class GridProblem:
    """A rectangular grid reachability instance."""

    name: str
    width: int
    height: int
    start: Coordinate
    goal: Coordinate
    obstacles: frozenset[Coordinate]

    def inside(self, cell: Coordinate) -> bool:
        x, y = cell
        return 0 <= x < self.width and 0 <= y < self.height

    def is_free(self, cell: Coordinate) -> bool:
        return self.inside(cell) and cell not in self.obstacles

    def validate(self) -> None:
        if self.width <= 0 or self.height <= 0:
            raise ValueError("Grid width and height must be positive.")
        if not self.inside(self.start):
            raise ValueError(f"Start cell {self.start} is outside the grid.")
        if not self.inside(self.goal):
            raise ValueError(f"Goal cell {self.goal} is outside the grid.")
        if self.start in self.obstacles:
            raise ValueError(f"Start cell {self.start} is an obstacle.")
        if self.goal in self.obstacles:
            raise ValueError(f"Goal cell {self.goal} is an obstacle.")
        for obstacle in self.obstacles:
            if not self.inside(obstacle):
                raise ValueError(f"Obstacle cell {obstacle} is outside the grid.")


def _coordinate(value: Iterable[int], field_name: str) -> Coordinate:
    items = list(value)
    if len(items) != 2 or not all(isinstance(v, int) for v in items):
        raise ValueError(f"{field_name} must be a pair of integers.")
    return items[0], items[1]


def load_grid(path: str | Path) -> GridProblem:
    """Load a grid problem from a JSON file."""
    path = Path(path)
    with path.open("r", encoding="utf-8") as handle:
        raw = json.load(handle)

    problem = GridProblem(
        name=str(raw.get("name", path.stem)),
        width=int(raw["width"]),
        height=int(raw["height"]),
        start=_coordinate(raw["start"], "start"),
        goal=_coordinate(raw["goal"], "goal"),
        obstacles=frozenset(_coordinate(cell, "obstacle") for cell in raw.get("obstacles", [])),
    )
    problem.validate()
    return problem
