# Benali
"""
BMC (Bounded Model Checking) Method

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
from z3 import sat, Solver

from usmpt.checkers.abstractchecker import AbstractChecker
from usmpt.exec.utils import STOP, send_signal_pids, set_verbose
from usmpt.ptio.formula import Formula
from usmpt.ptio.ptnet import PetriNet
from usmpt.ptio.verdict import Verdict


class BMC(AbstractChecker):
    """ Bounded Model Checking (BMC) method.

    Attributes
    ----------
    ptnet : PetriNet
        Initial Petri net.
    formula : Formula
        Reachability formula.
    induction_queue : Queue of int, optional
        Queue for the exchange with k-induction.
    show_model : bool
        Show model flag.
    """

    def __init__(self, ptnet: PetriNet, formula: Formula, verbose: bool = False) -> None:
        """ Initializer.

        Parameters
        ----------
        ptnet : PetriNet
            Initial Petri net.
        formula : Formula
            Reachability formula.
        """
        # Initial Petri net
        self.ptnet: PetriNet = ptnet

        # Formula to study
        self.formula: Formula = formula

        # Verbosity
        self.verbose: bool = verbose

    def prove(self, result: Queue[Verdict], concurrent_pids: Queue[list[int]]) -> None:
        """ Prover.

        Parameters
        ----------
        result : Queue of Verdict
            Queue to exchange the verdict.
        concurrent_pids : Queue of int
            Queue to get the PIDs of the concurrent methods.
        """
        set_verbose(self.verbose)

        info("[BMC] RUNNING")

        if self.prove_helper():
            result.put(Verdict.REACHABLE)

        # Terminate concurrent methods
        if not concurrent_pids.empty():
            send_signal_pids(concurrent_pids.get(), STOP)

    def prove_helper(self) -> bool:
        """ Prover to complete.

        Returns
        -------
        bool
            Verdict (True if reachable).
        """
        info("[BMC] > Solver initialization")
        solver = Solver(logFile="test")

        info("[BMC] > Declaration of the places from the Petri net (iteration: 0)")
        self.ptnet.declare_places(solver, 0)

        info("[BMC] > Set the initial marking of the Petri net")
        self.ptnet.set_initial_marking(solver, 0)

        info("[BMC] > Push")
        solver.push()

        info("[BMC] > Assert the formula to check the satisfiability (iteration: 0)")
        self.formula.set(solver, self.ptnet, 0)

        k = 0
        while solver.check() != sat:

            info("[BMC] > Pop")
            solver.pop()

            k += 1
            info(f"[BMC] > k = {k}")

            info(f"[BMC] > Declaration of the places from the Petri net (iteration: {k})")
            self.ptnet.declare_places(solver, k)

            info(f"[BMC] > Transition relation: {k - 1} -> {k}")
            self.ptnet.transition_relation(solver, k - 1)

            info("[BMC] > Push")
            solver.push()

            info(f"[BMC] > Formula to check the satisfiability (iteration: {k})")
            self.formula.set(solver, self.ptnet, k)
            
        return True
