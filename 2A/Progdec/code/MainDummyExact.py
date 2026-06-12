#!/usr/bin/env python3

from BMC import BMC
from DummyTransitionSystem import DummyTransitionSystem

""" A simple exact solving using the BMC algorithm for DummyTransitionSystem.
"""

def main():
    max_n_of_steps = 6

    print("Trying to solve dummy pb (should work)")
    
    simulation = BMC(DummyTransitionSystem(2, max_n_of_steps, 8),
                     max_n_of_steps, False)
    
    simulation.solve(-1)

    print("\nTrying to solve dummy pb (should NOT work)")
    
    simulation = BMC(DummyTransitionSystem(3, max_n_of_steps, 17),
                     max_n_of_steps, False)
    
    simulation.solve(-1)

    print("\nTrying to solve dummy pb (should NOT work)")
    
    simulation = BMC(DummyTransitionSystem(2, max_n_of_steps, -6),
                     max_n_of_steps, False)
    
    simulation.solve(-1)


if __name__ == "__main__":
    main()