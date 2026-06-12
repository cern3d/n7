#!/usr/bin/env python3

""" A simple simulation using the BMC algorithm for DummyTransitionSystem.
"""

from BMC import BMC
from DummyTransitionSystem import DummyTransitionSystem

def main():
    max_n_of_steps = 6

    dummy_system = DummyTransitionSystem(3, max_n_of_steps, 6)
    simulation = BMC(dummy_system, max_n_of_steps,  True)

    simulation.solve(-1)


if __name__ == "__main__":
    main()