# Benali
"""
K-Induction Method

Based on:
Mary Sheeran, Satnam Singh, and Gunnar Stälmarck.
Checking safety properties using induction and a SAT-solver. 
FMCAD 2000

Adapted for Petri nets

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
from z3 import Solver, sat

from usmpt.checkers.abstractchecker import AbstractChecker
from usmpt.exec.utils import STOP, send_signal_pids, set_verbose
from usmpt.ptio.formula import Formula
from usmpt.ptio.ptnet import PetriNet
from usmpt.ptio.verdict import Verdict


class KInduction(AbstractChecker):
    """ k-induction method.

    Attributes
    ----------
    ptnet : PetriNet
        Initial Petri net.
    formula : Formula
        Reachability formula.
    solver : Z3
        SMT solver (Z3).
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
        self.verbose : bool = verbose

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

        info("[K-INDUCTION] RUNNING")

        verdict = self.prove_helper()

        # Put the result in the queue
        if verdict is True:
            result.put(Verdict.REACHABLE)
        else:
            result.put(Verdict.NOT_REACHABLE)

        # Terminate concurrent methods
        if not concurrent_pids.empty():
            send_signal_pids(concurrent_pids.get(), STOP)

    ######################
    # TODO: Sect. 2.3.3. #
    ######################
    def prove_helper(self) -> bool:
        """ Prover to complete.

        Returns
        -------
        bool
            Verdict (True if reachable, False if not reachable)
        """
        k = 0

        while True:

            induction_solver = Solver()

            self.ptnet.declare_places(induction_solver, k + 1)

            for i in range(k):

                # ¬F(x_i)
                self.formula.set(
                    induction_solver,
                    self.ptnet,
                    i,
                    negation=True
                )

                self.ptnet.transition_relation(induction_solver, i)

            self.formula.set(induction_solver, self.ptnet, k)

             


            if induction_solver.check() == sat:
                k += 1
                continue

           

            bmc_solver = Solver()

            self.ptnet.declare_places(bmc_solver, k)

            self.ptnet.set_initial_marking(bmc_solver, 0)

            for i in range(k):
                self.ptnet.transition_relation(bmc_solver, i)

            self.formula.set(bmc_solver, self.ptnet, k)

            if bmc_solver.check() == sat:
                return True

            return False
    ######################