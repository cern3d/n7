from TransitionSystem import TransitionSystem

import z3

class DummyTransitionSystem(TransitionSystem):
    """ A dummy transition system. The state of the transition system is
        modeled by a Z3 integer.
    """

    def __init__(self, starting_number: int, max_n_of_steps: int, target: int):
        """ Creates a dummy transition system.
        
        Parameters
        ----------
        startingNumber
            the int representing the initial state of the system
        maxNOfSteps
            the maximum number of states to consider
        target 
            the int value to attain (cf. transitionFormula)
        """
        self.start = starting_number
        self.states = [
            z3.Int(f"i_{i}") for i in range(max_n_of_steps + 1)
        ]
        self.target = target

    def transition_formula(self, step: int) -> z3.BoolRef:
        """ Expresses transition semantics: the state integer at (step + 1)
            is the state integer at step + 2.
        """
        return self.states[step + 1] == self.states[step] + 2

    def initial_state_formula(self) -> z3.BoolRef:
        return self.states[0] == self.start

    def final_state_formula(self, step: int) -> z3.BoolRef:
        """ State integer at step is equal to the target integer.
        """
        return self.states[step] == self.target

    def print_params(self):
        print("\nDummy transition system parameters:")
        print(f"- starting int: {self.start}")
        print(f"- target int  : {self.target}")

    def print_model(self, model: z3.ModelRef, steps: int):
        values = []
        for step in range(steps + 1):
            val = model.evaluate(self.states[step], model_completion=True)
            values.append(str(val))
        print(" -> ".join(values))