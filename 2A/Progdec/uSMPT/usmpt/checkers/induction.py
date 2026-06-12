# Benali
"""
Inductive Method

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

from usmpt.ptio.formula import Formula
from usmpt.ptio.ptnet import PetriNet

__author__ = "Nicolas AMAT, ONERA/DTIS, Université de Toulouse"
__contact__ = "nicolas.amat@onera.fr"
__license__ = "GPLv3"
__version__ = "1.0"

from logging import info
from multiprocessing import Queue
from typing import Optional
from z3 import sat, Solver, unsat

from usmpt.checkers.abstractchecker import AbstractChecker
from usmpt.exec.utils import STOP, send_signal_pids, set_verbose
from usmpt.ptio.verdict import Verdict


class Induction(AbstractChecker):
    """
    Induction method.
    """

    def __init__(self, ptnet : PetriNet, formula : Formula, verbose: bool = False):
        """ Initializer.

        Parameters
        ----------
        ptnet : PetriNet
            Initial Petri net.
        formula : Formula
            Reachability formula.
        verbose : bool, optional
            Verbose flag.
        """
        # Initial Petri net
        self.ptnet: PetriNet = ptnet

        # Formula to study
        self.formula: Formula = formula

        # Verbosity
        self.verbose: bool = verbose

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

        info("[INDUCTION] RUNNING")

        induction = self.prove_helper()

        # Put the result in the queue
        if induction is True:
            result.put(Verdict.REACHABLE)
        elif induction is False:
            result.put(Verdict.NOT_REACHABLE)
        elif induction is None:
            result.put(Verdict.UNKNOWN)

        # Terminate concurrent methods
        if induction is not None and not concurrent_pids.empty():
            send_signal_pids(concurrent_pids.get(), STOP)

    ######################
    # TODO: Sect. 2.3.2. #
    ######################
    def prove_helper(self) -> Optional[bool]:
        """ Prover to complete.

        Returns
        -------
        bool, optional
            Verdict (True if reachable, False if not reachable, None if unknown).
        """
        solver = Solver()

        self.ptnet.declare_places(solver, 0)
        self.ptnet.set_initial_marking(solver, 0)

        self.formula.set(solver, self.ptnet, 0)

        if solver.check() == sat:
            return True


        solver = Solver()

        self.ptnet.declare_places(solver, 1)

        self.formula.set(solver, self.ptnet, 0, negation=True)

        self.ptnet.transition_relation(solver, 0)

        self.formula.set(solver, self.ptnet, 1)

        if solver.check() == unsat:
            return False

        return None
    ######################