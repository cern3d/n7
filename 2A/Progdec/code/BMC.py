from z3 import *

class BMC:
    """ A Bounded Model-Checking (BMC) motor on a transition system.
    """

    def __init__(self, system, max_n_of_steps, simulation):
        """ Create a BMC instance for a particular transition system.
            
        Parameters
        ----------
        system
            the transition system
        maxNOfSteps
            the maximum number of unrolling steps
        useApprox
            to use approximate resolution when needed
        simulation 
            if true, then BMC is used to simulate the system
            In this case, no approximate solver is used.
        """
        self.system = system
        self.max_n_of_steps = max_n_of_steps
        self.simulation = simulation

    def print_params(self):
        print("\nBMC parameters:")
        print(f"- max nb of steps: {self.max_n_of_steps}")
        self.system.print_params()

    def solve(self, timeout):
        """ This method tries to exactly solve the BMC problem. It unrolls
            at most maxNOfSteps transitions starting from initial state.            
            
            For each iteration of BMC:          
            
            1. a transition formula for the next step is added to the solver
            2. the final state formula for the next step is pushed into the solver
            3. if the problem is SAT then solution is printed
               else if the problem is UNSAT, the final state formula is popped
               and the next iteration is done           
            
               If the problem is UNKNOWN, the UNKNOWN status is returned.
            4. if the problem is UNSAT for all iterations, the UNSAT status
               is returned          
            
            If the BMC solver is configured for simulation (cf. BMC),
            then the final state formula is always True and the BMC is executed
            exactly maxNOfSteps.

        Parameters
        ----------
        timeout
            the timeout to use. If negative, no timeout is used
        """
        solver = Solver()
        # FIXME Add the initial state formula and save the context

        if self.simulation:
            print("\nsimulation, final state formula is always true!")
        elif timeout > 0:
            p = ParamsRef()
            p.set("timeout", timeout)
            solver.set(p)
            print(f"\nsolveExact with timeout {timeout}")
        else:
            print("\nsolveExact without timeout")

        # FIXME Encode the BMC algorithm with both solving and simulation handling

        if self.simulation:
            return sat
        else:
            return unsat