from abc import ABC, abstractmethod
from z3 import BoolRef, ExprRef, IntVal
import z3


class TransitionSystem(ABC):
    """ A simple abstract class representing a transition system.
        A final state formula, i.e. a formula to hold after a certain
        number of steps must also be provided.
    """

    @abstractmethod
    def transition_formula(self, step: int) -> BoolRef:
        """ A Z3 boolean expression that holds if there is a valid
            transition from state at step and state at step + 1.
        """
        pass

    @abstractmethod
    def initial_state_formula(self) -> BoolRef:
        """ A Z3 boolean expression that holds for the initial state.
        """
        pass

    @abstractmethod
    def final_state_formula(self, step: int) -> BoolRef:
        """ A Z3 boolean expression that holds if state at step verifies
            the expected property.
        """
        pass

    @abstractmethod
    def print_params(self):
        """ Prints system parameters.
        """
        pass

    @abstractmethod
    def print_model(self, m: z3.ModelRef, steps: int):
        """ Prints a model of the transition system until steps transitions.
            Beware, the model MUST exist!
        """
        pass