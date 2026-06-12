"""
Formula Module

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

from usmpt.ptio.ptnet import PetriNet

__author__ = "Nicolas AMAT, ONERA/DTIS, Université de Toulouse"
__contact__ = "nicolas.amat@onera.fr"
__license__ = "GPLv3"
__version__ = "1.0"

from abc import ABC, abstractmethod
from collections import deque
import operator
from re import search, split
from typing import Optional, Sequence
from z3 import *

from usmpt.ptio.verdict import Verdict

LTL_TO_BOOLEAN_OPERATORS = {
    '-': 'not',
    '/\\': 'and',
    '\\/': 'or'
}

LTL_TO_BOOLEAN_CONSTANTS = {
    'T': True,
    'F': False
}

OPERATOR_TO_Z3 = {
    'not': Not,
    'and' : And,
    'or': Or,
    '<=': operator.le,
    '<': operator.lt,
    '>=': operator.ge,
    '>': operator.gt,
    '=': operator.eq,
    '!=': operator.ne
}


class Formula:
    """ Properties.

    Attributes
    ----------
    F : Expression
        Reachability formula.
    """

    def __init__(self, formula: Optional[str] = None, path_formula: Optional[str] = None) -> None:
        """ Initializer.

        Parameters
        ----------
        formula : str, optional
            Reachability formula.
        path_formula : str, optional
            Path to reachability formula.
        """
        if formula is None:
            if path_formula is not None:
                with open(path_formula, 'r') as fp:
                    formula = fp.read().strip()
            else:
                raise ValueError

        self.F: Expression = self.parse_formula(formula)

    def __str__(self) -> str:
        """ Properties to textual format.

        Returns
        -------
        str
            Debugging format.
        """
        return str(self.F)

    def set(self, solver: Solver, ptnet: PetriNet, k: int, negation: bool = False) -> None:
        """ Set the property.

        Parameters
        ----------
        k : int, optional
            Iteration number.
        negation : bool, optional
            Negation flag.
        """
        return solver.add(self.F.set(ptnet, k) if not negation else Not(self.F.set(ptnet, k)))

    def parse_formula(self, formula: str) -> Expression:
        """ Formula parser.

        Parameters
        ----------
        formula : str
            Formula (.ltl format).

        Returns
        -------
        Expression
            Parsed formula.
        """
        def _tokenize(s):
            tokens = []
            buffer, last = "", ""
            open_brace = False

            for c in s:

                if c == ' ':
                    continue

                elif (c == '/' and last == '\\') or (c == '\\' and last == '/'):
                    if buffer:
                        tokens.append(buffer)
                    tokens.append(last + c)
                    buffer, last = "", ""

                elif (c == '-' and not open_brace) or c in ['(', ')']:
                    if last:
                        tokens.append(buffer + last)
                    tokens.append(c)
                    buffer, last = "", ""

                elif c == '{':
                    open_brace = True

                elif c == '}':
                    open_brace = False

                else:
                    buffer += last
                    last = c

            if buffer or last:
                tokens.append(buffer + last)

            return tokens

        def _member_constructor(member):
            places, integer_constant, multipliers = [], 0, {}

            for element in member.split('+'):
                if element.isnumeric():
                    integer_constant += int(element)
                else:
                    split_element = element.split('*')
                    variable = split_element[-1]
                    places.append(variable)

                    if len(split_element) > 1:
                        multipliers[variable] = int(split_element[0])

            if places:
                return TokenCount(places, multipliers)
            else:
                return IntegerConstant(integer_constant)

        # Number of opened parenthesis (not close)
        open_parenthesis = 0

        # Stacks: operators and operands
        stack_operator: deque[tuple[str, int]] = deque()
        stack_operands: deque[list[Expression]] = deque([[]])

        # Current operator
        current_operator = None

        # Parse atom
        parse_atom = False

        for token in _tokenize(formula):

            if token in ['', ' ']:
                continue

            if token in ['-', '/\\', '\\/']:
                # Get the current operator
                token_operator = LTL_TO_BOOLEAN_OPERATORS[token]

                if current_operator:
                    # If the current operator is different from the previous one, construct the previous sub-formula
                    if current_operator != token_operator:
                        stack_operands[-1] = [StateFormula(stack_operands[-1], stack_operator.pop()[0])]
                else:
                    # Add the current operator to the stack
                    stack_operator.append((token_operator, open_parenthesis))
                    current_operator = token_operator

            elif token == '(':
                # Increment the number of parenthesis
                open_parenthesis += 1

                # Add new current operands list
                stack_operands.append([])

                # Reset the last operator
                current_operator = None

            elif token == ')':
                # Fail if no open parenthesis previously
                if not open_parenthesis:
                    raise ValueError("Unbalanced parentheses")

                # Decrease the number of open parenthesis
                open_parenthesis -= 1

                # Add to the previous list
                operands = stack_operands.pop()
                if current_operator:
                    stack_operands[-1].append(StateFormula(operands, stack_operator.pop()[0]))
                else:
                    stack_operands[-1].append(operands[0])

                current_operator = stack_operator[-1][0] if stack_operator and stack_operator[-1][-1] == open_parenthesis else None

            elif token in ['T', 'F']:
                # Construct BooleanConstant
                stack_operands[-1].append(BooleanConstant(token == 'T'))

            else:
                # Construct Atom
                if search("(<=|>=|!=|<|>|=)", token):
                    if parse_atom:
                        _, operator, right = split("(<=|>=|<|>|=)", token)
                        stack_operands[-1].append(Atom(stack_operands[-1].pop(), _member_constructor(right), operator))
                        parse_atom = False

                    else:
                        left, operator, right = split("(<=|>=|!=|<|>|=)", token)
                        stack_operands[-1].append(Atom(_member_constructor(left), _member_constructor(right), operator))
                else:
                    stack_operands[-1].append(_member_constructor(token))
                    parse_atom = True

        if open_parenthesis:
            raise ValueError("Unbalances parentheses")

        if stack_operator:
            operands = stack_operands.pop()
            operator = stack_operator.pop()[0]
            return StateFormula(operands, operator)
        else:
            return stack_operands.pop()[0]


    def result(self, verdict: Verdict) -> str:
        """ Return the result according to the reachability of the feared events R.

        Parameters
        ----------
        verdict : Verdict
            Verdict of the formula.

        Returns
        -------
        str
            "REACHABLE", "NOT REACHABLE" or "UNKNOWN".
        """
        if verdict == Verdict.REACHABLE:
            return "REACHABLE"
        elif verdict == Verdict.NOT_REACHABLE:
            return "NOT REACHABLE"

        return "UNKNOWN"


class Expression(ABC):
    """ Expression.
    """

    @abstractmethod
    def __str__(self) -> str:
        """ SimpleExpression to textual format.

        Returns
        -------
        str
            Debugging format.
        """
        pass

    @abstractmethod
    def set(self, ptnet: PetriNet, k: int) -> None:
        """ Assert the SimpleExpression.

        Parameters
        ----------
        ptnet : PetriNet
            Corresponding Petri net for accessing state variables
        k : int
            State index.
        """
        pass


class StateFormula(Expression):
    """ StateFormula.

    Attributes
    ----------
    operands : list of Expression
        A list of operands.
    operator : str
        A boolean operator (not, and, or).
    """

    def __init__(self, operands: Sequence[Expression], operator: str) -> None:
        """ Initializer.

        Parameters
        ----------
        operands : Sequence[Expression]
            List of operands.
        operator : str
            Operator (not, and, or).

        Raises
        ------
        ValueError
            Invalid operator for a StateFormula.
        """
        self.operands: Sequence[Expression] = operands

        self.operator: str = ''
        if operator in ['not', 'and', 'or']:
            self.operator = operator
        else:
            raise ValueError("Invalid operator for a state formula")

    def __str__(self):
        if self.operator == 'not':
            return "(not {})".format(self.operands[0])

        text = " {} ".format(self.operator).join(map(str, self.operands))

        if len(self.operands) > 1:
            text = "({})".format(text)

        return text

    def set(self, ptnet, k):
        operands = [operand.set(ptnet, k) for operand in self.operands]

        if self.operator == 'not':
            return OPERATOR_TO_Z3[self.operator](operands[0])

        return OPERATOR_TO_Z3[self.operator](operands)


class Atom(Expression):
    """ Atom.

    Attributes
    ----------
    left_operand : Expression
        Left operand.
    right_operand : Expression
        Right operand.
    operator : str
        Operator (=, <=, >=, <, >, !=).
    """

    def __init__(self, left_operand: Expression, right_operand: Expression, operator: str) -> None:
        """ Initializer.

        Parameters
        ----------
        left_operand : Expression
            Left operand.
        right_operand : Expression
            Right operand.
        operator : str
            Operator (=, <=, >=, <, >, !=).

        Raises
        ------
        ValueError
            Invalid operator for an Atom.
        """
        if operator not in ['=', '<=', '>=', '<', '>', '!=']:
            raise ValueError("Invalid operator for an atom")

        self.left_operand: Expression = left_operand
        self.right_operand: Expression = right_operand

        self.operator: str = operator

    def __str__(self):
        return "({} {} {})".format(self.left_operand, self.operator, self.right_operand)

    def set(self, ptnet, k):
        return OPERATOR_TO_Z3[self.operator](self.left_operand.set(ptnet, k), self.right_operand.set(ptnet, k))



class BooleanConstant(Expression):
    """ Boolean constant.

    Attributes
    ----------
    value : bool
        A boolean constant.
    """

    def __init__(self, value: bool) -> None:
        """ Initializer.

        Parameters
        ----------
        value : bool
            A boolean constant.
        """
        self.value: bool = value

    def __str__(self):
        return str(self.value)

    def set(self, ptnet, k):
        return self.value
    

class TokenCount(Expression):
    """ Token count.

    k_1 * p_1 + ... + k_n * p_n + K

    Attributes
    ----------
    places : list of Places
        A list of places to sum.
    multipliers : dict of Place: int, optional
        Place multipliers (missing if 1).
    integer_constant : int, optional
        Constant.
    """

    def __init__(self, places: list[str], multipliers: Optional[dict[str, int]] = None, integer_constant: Optional[int] = None):
        """ Initializer.

        Parameters
        ----------
        places : list of str
            A list of places to sum.
        multipliers : dict of Place: int, optional
            Place multipliers (missing if 1 or 0).
        integer_constant : int, optional
            Constant.
        """
        self.places: list[str] = places
        self.multipliers: Optional[dict[str, int]] = multipliers
        self.integer_constant: Optional[int] = integer_constant

    def __str__(self) -> str:
        text = ' + '.join(map(lambda pl: pl if self.multipliers is None or pl not in self.multipliers else "({}.{})".format(self.multipliers[pl], pl), self.places))

        if self.integer_constant:
            text += " + " + str(self.integer_constant)

        return text

    def set(self, ptnet: PetriNet, k: int) -> str:
        def place_helper(pl, k):
            pl_var = ptnet.states[k][pl]
            return pl_var if self.multipliers is None or pl not in self.multipliers else self.multipliers[pl] * pl_var

        places = [place_helper(pl, k) for pl in self.places]

        if self.integer_constant:
            places.append(self.integer_constant)

        if len(self.places) > 1:
            return Sum(places)
        return places[0]    

class IntegerConstant(Expression):
    """ Integer constant.

    Attributes
    ----------
    value : int
        Constant.
    """

    def __init__(self, value: int) -> None:
        """ Initializer.

        Parameters
        ----------
        value : int
            Constant.
        """
        self.value = value

    def __str__(self):
        return str(self.value)

    def set(self, ptnet, k):
        return self.value

