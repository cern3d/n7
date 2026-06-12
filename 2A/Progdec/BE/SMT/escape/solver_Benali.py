from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Optional

from z3 import Abs, And, Int, Not, Or, Solver, sat

from escape.grid import Coordinate, GridProblem

path = Optional[list[Coordinate]]

"""
This file contains the functions that must be completed for the exam.

The goal is to implement a Bounded Model Checking (BMC) algorithm that searches
for the shortest path from the start position to the goal position, up to a
given maximum bound.

A problem is represented by an instance of the `GridProblem` class.

Useful attributes of `problem`:
- problem.width:
    Width of the grid.
- problem.height:
    Height of the grid.
- problem.start:
    Initial position of the robot as a tuple `(x, y)`.
- problem.goal:
    Goal position as a tuple `(x, y)`.
- problem.obstacles:
    List of obstacle coordinates. Each obstacle is a tuple `(x, y)`.

Coordinates start at `(0, 0)`.

Examples of data accesses:
- problem.width gives the width of the grid.
- problem.height gives the height of the grid.
- problem.start[0] gives the x-coordinate of the initial position.
- problem.start[1] gives the y-coordinate of the initial position.
- problem.goal[0] gives the x-coordinate of the goal position.
- problem.goal[1] gives the y-coordinate of the goal position.
- problem.obstacles[0] gives the first obstacle coordinate.
- problem.obstacles[0][0] gives the x-coordinate of the first obstacle.
- problem.obstacles[0][1] gives the y-coordinate of the first obstacle.
"""

def create_all_state_variables(max_bound: int) -> Any:
    """
    TODO - Task 1:
    Create the decision variables needed to represent a path of length
    at most `max_bound`.

    In a BMC encoding, each step usually has two variables:
    one for the x-coordinate and one for the y-coordinate.

    For example, for a bound of 3, we may need variables representing:
    - position at step 0
    - position at step 1
    - position at step 2
    - position at step 3

    Note:
    You may change the arguments or return type of this function if needed.
    """
    vars = []

    for t in range(max_bound + 1):
        x = Int(f"x_{t}")
        y = Int(f"y_{t}")
        vars.append((x, y))

    return vars




    return Vars

def set_initial_state(solver, problem, x0, y0) -> None:
    """
    TODO - Task 2:
    Add constraints to the solver forcing the first position of the robot
    to be equal to the initial position of the problem.

    The variables `x0` and `y0` represent the robot position at time 0.

    Note:
    You may change the arguments of this function if needed.
    """
    solver.add((x0,y0)==(problem.start[0].problem.start[1]))

def transition_relation(solver, problem, x_now, y_now, x_next, y_next):
    """
    TODO - Task 3:
    Add constraints describing the valid moves of the robot from the current
    position `(x_now, y_now)` to the next position `(x_next, y_next)`.

    A valid transition should ensure that:
    - the robot stays inside the grid;
    - the robot does not move onto an obstacle;
    - the robot moves according to the allowed movement rules.

    The robot may move one cell at a time:
    - left
    - right
    - up
    - down

    Note that you can use the abs() function in Z3. Exemple of syntax: `solver.add(abs(x + y) == 1)`

    Note:
    You may change the arguments of this function if needed.
    """
    solver.add(Or([(x_next+i,y_next+j)==(x_now,y_now) for i in [-1,1] for j in [-1,1]]))
    solver.add((problem.obstacle[i][0],problem.obstacle[i][1])!=(x_next,y_next) for i in range(len(problem.obstacle)))
    solver.add(And(0 <=x_next <= problem.width ,0 <= y_next<= problem.height))

def set_goal(solver, problem, x, y):
    """
    TODO - Task 4:
    Add constraints forcing the given position `(x, y)` to be equal to the
    goal position of the problem.

    Note:
    You may change the arguments of this function if needed.
    """
    solver.add((x,y) == (problem.goal[0],problem.goal[1]))



def solve(problem: GridProblem, max_bound: int) -> path:
    """
    TODO - Task 5:
    Implement a BMC-style algorithm that searches for the shortest path from
    the initial position to the goal position, using bounds from 0 up to
    `max_bound`.

    The function should return:
    - a list of coordinates if a path exists;
    - None if no path exists up to `max_bound`.

    A path is a list of coordinates, where each coordinate is a tuple `(x, y)`.

    Example:
    [(0, 0), (1, 0), (1, 1), (2, 1)]

    Suggested :
    1. Try paths of length 0, then 1, then 2, and so on up to `max_bound`.
    2. If no bound works, return None.

    Useful Z3 commands:
    - Check satisfiability:
        solver.check() == sat

    - Get the model:
        model = solver.model()

    - Get the integer value of a variable:
        value = model[x].as_long()

    - Temporarily add a constraint C:
        solver.push()
        solver.add(C)
        solver.check()
        solver.pop()
    """
    path = None

    solver = Solver(logFile="solver_input.smt2")
    

    k = 0
    while solver.check() != sat and k<=max_bound:

        solver.pop()

        k += 1

        Vars = create_all_state_variables(k)

        set_initial_state(solver,problem,Vars[0][0],Vars[0][1])

        for t in range(k):
            transition_relation( solver, problem, Vars[t][0], Vars[t][1], Vars[t + 1][0], Vars[t + 1][1])

        set_goal(solver, problem, Vars[k+1][0], Vars[k+1][1])



        solver.push()


        if solver.check() == sat:

            model = solver.model()

            for x, y in Vars:
                path.append(( model[x].as_long(), model[y].as_long()))

            return path

        
    return path


"""
TODO - Task 6:
In your own words, what is an NP-complete problem?

Answer:

an NP-complete problem is a problem that can be verified in polynomial time but solved in at most exponential time. if a problem is np-complete it is equivalent to all other np-complete problems.


"""