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

for i in range(0, N):
    for j in range(0, N):
        for v in range(1, N + 1):
            Vars[i, j, v] = Bool("(" + str(i) + ", " + str(j) + ", " + str(v) + ")")

# create solver
s = Solver()

# define constraints

time_start_gen = time.process_time()

# each cell has a value
for row in range(0, N):
    for col in range(0, N):
        s.add(Or([Vars[(row, col, value)] for value in range(1, N + 1)]))
        if VERBOSE:
            print("cell: adding " + str(Or([Vars[(row, col, value)] for value in range(1, N + 1)])))

# row constraints
for row in range(0, N):
    for value in range(1, N + 1):
        # each value appears at least one time in each row
        s.add(Or([Vars[(row, col, value)] for col in range(0, N)]))
        if VERBOSE:
            print("row: adding " + str(Or([Vars[(row, col, value)] for col in range(0, N)])))
        # each value appears at most one time in each row
        for col in range(0, N):
            for sec_col in range(0, N):
                if not col == sec_col:
                    s.add(Implies(Vars[row, col, value], Not(Vars[row, sec_col, value])))
                    if VERBOSE:
                        print("row: adding " + str(Implies(Vars[row, col, value], Not(Vars[row, sec_col, value]))))


# col constraints (the same...)
for col in range(0, N):
    for value in range(1, N + 1):
        # each value appears at least one time in each col
        s.add(Or([Vars[(row, col, value)] for row in range(0, N)]))
        if VERBOSE:
            print("col: adding " + str(Or([Vars[(row, col, value)] for col in range(0, N)])))
        # each value appears at most one time in each col
        for row in range(0, N):
            for sec_row in range(0, N):
                if not row == sec_row:
                    s.add(Implies(Vars[row, col, value], Not(Vars[sec_row, col, value])))
                    if VERBOSE:
                        print("col: adding " + str(Implies(Vars[row, col, value], Not(Vars[row, sec_col, value]))))

# subgrids constraint : each value is present in one cell of the subgrid
for sg_row in [N_INIT * i for i in range(0, N_INIT)]:
    for sg_col in [N_INIT * i for i in range(0, N_INIT)]:
        for value in range(1, N + 1):
            s.add(Or([Vars[sg_row + x, sg_col + y, value] for x in range(0, N_INIT) for y in range(0, N_INIT)]))
            if VERBOSE:
                print("subgrid: adding " + str(Or([Vars[sg_row + x, sg_col + y, value] for x in range(0, 3) for y in range(0, 3)])))

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

# define a problem (cf. sudoku 16-274 from Le Monde 11/18/2016 by Yan Georget)
s.push()
s.add([Vars[1, 6, 8],
       Vars[1, 7, 5],
       Vars[1, 8, 1],
       Vars[2, 3, 1],
       Vars[2, 5, 2],
       Vars[2, 7, 9],
       Vars[2, 8, 4],
       Vars[3, 5, 8],
       Vars[4, 4, 3],
       Vars[4, 6, 6],
       Vars[4, 7, 4],
       Vars[5, 0, 5],
       Vars[5, 3, 6],
       Vars[5, 7, 7],
       Vars[5, 8, 3],
       Vars[6, 0, 6],
       Vars[7, 1, 4],
       Vars[7, 2, 3],
       Vars[7, 3, 7],
       Vars[7, 4, 2],
       Vars[8, 1, 2],
       Vars[8, 2, 9],
       Vars[8, 3, 8],
       Vars[8, 6, 3]])

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

# using an easy sudoku
s.add(read_sudoku('easy.csv'))

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
        cube = list(filter(lambda x: model[x] and x not in init_const, [Vars[row, col, value] for row in range(0, N) for col in range(0, N) for value in range(1, N + 1)]))
        s.add(Not(And(cube)))
        if not TK_GUI:
            input()
    else:
        break
