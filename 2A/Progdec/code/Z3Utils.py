from z3 import *

""" Some utility functions for Z3.
"""

def at_most_one(*exprs):
    """ Returns a Z3 boolean expression representing a formula
        true iff at most one boolean expression in exprs is true.
    """
    conjuncts = []

    for expr in exprs:
        other_exprs = [e for e in exprs if e is not expr]

        if other_exprs:
            big_or = Or(*other_exprs)
            res = Implies(expr, Not(big_or))
        else:
            res = True

        conjuncts.append(res)

    return And(*conjuncts)

def exactly_one(*exprs):
    """ Returns a Z3 boolean expression representing a formula
        true iff exactly one boolean expression in exprs is true.
    """
    return And(Or(*exprs), at_most_one(*exprs))