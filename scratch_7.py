# Copiright Trevor van Hoof (c) 2018

import os
from multiprocessing import Pool
from itertools import permutations


def run(N):
    formulae = []
    numbers = range(N + 1)[1:]
    for combination in permutations(numbers):
        def getOp(N):
            for op in '+-*/':
                out = [op]
                if N:
                    for sub in getOp(N - 1):
                        yield out + sub
                else:
                    yield out

        for ops in getOp(N - 1):
            out = []
            for i in range(N - 1):
                out.extend((combination[i], ops[i]))
            out.append(combination[-1])
            formulae.append(' '.join(str(x) for x in out))

    seq = []
    for formula in set(formulae):
        sections = formula.split(' ')
        subFormulae = []
        brackets(subFormulae, sections)

        for subFormula in subFormulae:
            try:
                val = eval(subFormula)
            except ZeroDivisionError:
                continue
            if val == int(val) and val > 0:
                seq.append(val)

    res = sorted(list(set(seq)))
    for i, v in enumerate(res):
        if i + 1 != v:
            print(i + 1)
            return
    print(len(res) + 1)


def brackets(known, sections):
    res = ' '.join(sections)
    if res not in known:
        known.append(res)
    N = int((len(sections) - 1) / 2)
    for i in range(N):
        for j in range(N - 1):
            o = 3 + j + j
            newSections = sections[:i + i] + ['(%s)' % ' '.join(sections[i + i:o + i + i])] + sections[i + i + o:]
            while '' in newSections:
                newSections.remove('')
            brackets(known, newSections)


if __name__ == '__main__':
    run(1)  # 2
    run(2)  # 4
    run(3)  # 10
    run(4)  # 29
    run(5)  # 76
    run(6)  # 284
    pass

# ((6 * 5) + 1) * ((2 + 4) + 3)
# 279
