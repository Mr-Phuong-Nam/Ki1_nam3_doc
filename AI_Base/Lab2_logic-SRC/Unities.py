def get_literals(line: str):
    """
    Separate a clause into a list of literals
    """

    # Each literal is separated by OR
    literals = line.split("OR")

    # Remove spaces in each literal
    literals = [literal.strip() for literal in literals]

    return literals

def read_input(fileName: str):
    """
    Read input from file
    Return a statement and KB
    """
    # Each clause is stored as a list of literals
    # KB is a list of clauses
    a_statement = []
    kb = []

    with open(fileName, "r") as f:
        a_statement = get_literals(f.readline())
        N = int(f.readline().strip())

        for i in range(N):
            clause = get_literals(f.readline())
            # Ordering literals in a clause by alphabetical order
            clause.sort(key=lambda x: x.replace("-", ""))
            kb.append(clause)

    return a_statement, kb



def write_output(output, filename):
    f = open(filename, "w")

    for step in output:
        # write number of clauses generated in each step
        num_of_clauses = len(step)
        f.write(str(num_of_clauses) + "\n")
        # Num clauses = 0 -> there is no new clause generated -> a statement is not entailed by KB
        if num_of_clauses == 0:
            f.write("NO")
            return

        for clause in step:
            # Appeared "{}" -> a statement is entailed by KB
            if clause == ["{}"]:
                f.write(clause[0] + "\n")
                f.write("YES")
                return
            # Ordering literals in a clause by alphabetical order
            clause.sort(key=lambda x: x.replace("-", ""))

            for literal in clause:
                f.write(literal)
                # Connect literals in a clause with OR (except the last literal)
                if literal != clause[-1]:
                    f.write(" OR ")
            f.write("\n")