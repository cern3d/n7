from sudoku_pp import console_pp
from sudoku_pp import tk_pp
from z3 import *
import time

# normally, you should define a number NINIT and the dimension of the sudoku game is NINIT^2 x NINIT^2
N_INIT = 3
N = N_INIT**2

VERBOSE = False
TK_GUI = False

# define variables
Vars = {}

for i in range(N):
    for j in range(N):
        for v in range(1,N+1):
            Vars[i, j, v] = Bool("(" + str(i) + ", " + str(j) + ", " + str(v) + ")")

# create solver
s = Solver()

# define constraints

time_start_gen = time.process_time()

for i in range(N):
    for j in range(N):
            s.add(Or([Vars[i, j, v] for v in range(1,N+1)]))

# FIXME add row constraints
for i in range(N):
    for v in range(1,N+1):
        s.add(Or([Vars[i, j, v] for j in range(N)]))
        for col in range(0, N):
            for sec_col in range(0, N):
                if not col == sec_col:
                    s.add(Implies(Vars[i, col, v], Not(Vars[i, sec_col, v])))

# FIXME add col constraints (the same...)
for j in range(N):
    for v in range(1,N+1):
        s.add(Or([Vars[i, j, v] for i in range(N)]))
        for row in range(0, N):
            for sec_row in range(0, N):
                if not row == sec_row:
                    s.add(Implies(Vars[row, j, v], Not(Vars[sec_row, j, v])))

# FIXME subgrids constraint : each value is present in one cell of the subgrid
for bi in range(0, N, N_INIT):
    for bj in range(0, N, N_INIT):
        for v in range(1, N+1):
            s.add(
                Or([
                    Vars[i, j, v]
                    for i in range(bi, bi + N_INIT)
                    for j in range(bj, bj + N_INIT)
                ])
            )

# to print solution
def build_value_dict(model):
    vars = {}
    for row in range(0, N):
        for col in range(0, N):
            vars[row, col] = str(list(filter(lambda x: model[x],
                                             [Vars[row, col, value] for value in range(1, N + 1)]))[0]).split(', ')[2][0:-1]
    return vars

def pretty_print(model):
    if TK_GUI:
        tk_pp(build_value_dict(model))
    else:
        console_pp(build_value_dict(model))

# function to read Sudoku grids from file
def read_sudoku(filename):
    init_const = []
    with open(filename, 'r') as file:
        row = 0
        for data_row in file:
            data = data_row.strip('\n').split(',')
            for col, value in enumerate(data):
                if value:
                    init_const.append(Vars[(row, col, int(value))])
                    if VERBOSE:
                        print("({0}, {1}, {2}) added".format(row, col, value))
            row = row + 1
    return init_const

# define a problem (cf. sudoku 16-274 from Le Monde 11/18/2016 by Yan Georget)
s.push()

s.add(read_sudoku('easy.csv'))

time_end_gen = time.process_time()

# check
time_start_solve = time.process_time()

result = s.check()

time_end_solve = time.process_time()

if result == sat:
    print("SAT!")
    pretty_print(s.model())
else:
    print("UNSAT!")

print("\ntime needed to generate clauses: {0}s".format(time_end_gen - time_start_gen))
print("time needed to solve problem: {0}s".format(time_end_solve - time_start_solve))

print("\nstatistics:\n" + str(s.statistics()))

# go back to solver with only constraints
s.pop()
s.push()

# using an easy sudoku,
# FIXME Uncomment the following code to run on le monde grid
# s.add(read_sudoku('le-monde.csv'))
#
# time_start_solve = time.process_time()
#
# result = s.check()
#
# time_end_solve = time.process_time()
#
# if result == sat:
#     print("SAT!")
#     pretty_print(s.model())
# else:
#     print("UNSAT!")
#
# print("\ntime needed to generate clauses: {0}s".format(time_end_gen - time_start_gen))
# print("time needed to solve problem: {0}s".format(time_end_solve - time_start_solve))
#
# print("\nstatistics:\n" + str(s.statistics()))

# define an initial set of constraints
s.pop()
s.push()

print("\nTrying to find all solutions...\n")
init_const = read_sudoku("./multiple-sol.csv")

s.add(init_const)

while True:
    result = s.check()
    if result == sat:
        model = s.model()
        pretty_print(model)
        # FIXME Define cube to enumerate all solutions
        cube = {True}
        s.add(Not(And(cube)))
        if not TK_GUI:
            input()
    else:
        break
