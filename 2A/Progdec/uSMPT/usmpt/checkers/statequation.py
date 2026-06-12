# Benali
"""
State Equation Method

This file is part of uSMPT.

uSMPT is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

uSMPT is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with uSMPT. If not, see <https://www.gnu.org/licenses/>.
"""

from __future__ import annotations

__author__ = "Nicolas AMAT, ONERA/DTIS, Université de Toulouse"
__contact__ = "nicolas.amat@onera.fr"
__license__ = "GPLv3"
__version__ = "1.0"

from logging import info
from multiprocessing import Queue
from typing import Optional
from z3 import Solver, unsat

from usmpt.checkers.abstractchecker import AbstractChecker
from usmpt.exec.utils import STOP, send_signal_pids, set_verbose
from usmpt.ptio.formula import Formula
from usmpt.ptio.ptnet import PetriNet
from usmpt.ptio.verdict import Verdict


class StateEquation(AbstractChecker):
    """ State equation method.
    
    Note
    ----
    Check that the set of potentially reachable markings does not intersect any feared state. 
   
    Attributes
    ----------
    ptnet : PetriNet
        Initial Petri net.
    formula : Formula
        Reachability formula.
    """

    def __init__(self, ptnet: PetriNet, formula: Formula, verbose: bool = False) -> None:
        """ Initializer.
        """
        # Initial Petri net
        self.ptnet: PetriNet = ptnet

        # Formula to study
        self.formula: Formula = formula

        # Verbosity
        self.verbose = verbose

    def prove(self, result: Queue[Verdict], concurrent_pids: Queue[list[int]]):
        """ Prover.

        Parameters
        ----------
        result : Queue of Verdict
            Queue to exchange the verdict.
        concurrent_pids : Queue of int
            Queue to get the PIDs of the concurrent methods.
        """
        set_verbose(self.verbose)

        info("[STATE-EQUATION] RUNNING")

        verdict = self.prove_helper()

        # Put the result in the queue
        if verdict is False:
            result.put(Verdict.NOT_REACHABLE)
        else:
            result.put(Verdict.UNKNOWN)

        # Terminate concurrent methods
        if verdict is False and not concurrent_pids.empty():
            send_signal_pids(concurrent_pids.get(), STOP)

    ######################
    # TODO: Sect. 2.3.4. #
    ######################
    def prove_helper(self) -> Optional[bool]:
        """ Prover to complete.

        Returns
        -------
        bool, optional
            Verdict (False if not reachable, None otherwise).
        """
        solver = Solver()
        self.ptnet.state_equation(solver)
        self.formula.set(solver, self.ptnet, 0)

        if solver.check() == unsat:
            return False

        return None
    ######################