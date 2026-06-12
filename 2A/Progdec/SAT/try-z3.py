from z3 import *

############################################################

def checkAndPrint(s):
    # solving
    result = s.check()

    if result == sat:
        print("SAT!")
        # get the model
        m = s.model()
        print('a={0}, b={1}, c={2}\n'.format(m[a],
                                             m[b],
                                             m[c]))
    else:
     print("UNSAT!\n")

############################################################

# define variables
a = Bool('a')
b = Bool('b')
c = Bool('c')

# define problem
s = Solver()

s.add(Implies(a, b))
s.add(Or(Not(b), Not(c)))
s.add(a)

# printing assertions
print("Assertions in the problem:")
print(s.assertions())

# solving
checkAndPrint(s)

# making the problem UNSAT
print("adding c...")
s.push
s.add(c)
checkAndPrint(s)

s.pop
checkAndPrint(s)

############################################################
