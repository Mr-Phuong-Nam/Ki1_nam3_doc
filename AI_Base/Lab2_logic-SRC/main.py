from Unities import *


def PL_Resolve(clause1, clause2):
    """
    This function takes two clauses then applies the resolution rule to generate new clause.

    Parameters:
    clause1 (list): The first clause.
    clause2 (list): The second clause.

    Returns:
    list: A new clause generated from applying the resolution rule to clause1 and clause2.
    ["{}"]: Two clauses yield the empty clause, this indicates that a statement is entailed by KB.
    None: this indicates that applying the resolution rule is failed.
    """
    resolvent = None

    # We only return one resolvent because if there are more than one pair of complementary literals, the result will be (True v l1 v l2 v ...) -> True
    for literal1 in clause1:
        negation = ("-" + literal1).replace("--", "")

        if negation in clause2:

            # Merge two clauses
            resolvent = clause1 + clause2

            # Remove complementary literals
            resolvent.remove(literal1)
            resolvent.remove(negation)

            # Two clauses yield the empty clause -> the a statement is entailed by KB
            if len(resolvent) == 0:
                return ["{}"]
            
            # After removing complementary literals, if there are still complementary literals in the resolvent, the resolvent is always True -> no need to add to the KB5
            for literal in resolvent:
                negation = ("-" + literal).replace("--", "")
                if negation in resolvent:
                    return None

            # Remove redundant literals
            resolvent = list(set(resolvent))

            # Ordering literals in a clause by alphabetical order
            resolvent.sort(key=lambda x: x.replace("-", ""))

            
            return resolvent

    
    return resolvent


def PL_Resolution(a_statement, kb):
    """
    PL-Resolution algorithm

    This function implements the PL-Resolution algorithm, which is a method for determining
    whether a given statement (a_statement) is entailed by a knowledge base (kb) in propositional logic.

    Parameters:
    a_statement (list): The statement to be checked for entailment.
    kb (list): The knowledge base, which is a list of clauses.

    Returns:
    true or false: semantic information about whether a_statement is entailed by kb.
    list: A list of steps used in the PL-Resolution algorithm.

    """
    # The set of clauses in the CNF representation of (KB ∧ ¬α)
    clauses = kb

    # Negate the a statement, now each negation becomes a clause in kb
    for literal in a_statement:
        negation = ("-" + literal).replace("--", "")
        # append negation as a clause in kb
        clauses.append([negation])

    # Output is a list of steps used in PL-Resolution
    output = []
    new = clauses
    while True:
        # new is a list of new clauses generated from one iteration of PL-Resolution


        # prev_new is a list of new clauses generated from the previous iteration of PL-Resolution
        # First iteration, prev_new is clauses, then we will generate new clauses from each pair of clauses in clauses
        prev_new = new
        new = []

        # Generate new clauses from each pair of clauses in current clauses
        for i in range(len(clauses)):
            for j in range(len(prev_new)):
                # Choose ci from clauses and cj from prev_new to avoid resolving two clauses that have been resolved
                ci = clauses[i]
                cj = prev_new[j]
                
                resolvent = PL_Resolve(ci, cj)

                # Avoid adding duplicate clauses
                # None indicates that applying the resolution rule is failed
                if (resolvent not in new) and (resolvent not in clauses) and (resolvent != None):
                    new.append(resolvent)
                    # ["{}"] indicates that a is entailed by KB -> end the algorithm
                    if resolvent == ["{}"]:
                        output.append(new)
                        return True, output

        # There are no new clauses that can be added, KB does not entail α
        if len(new) == 0:
            output.append([])
            return False, output
        
        # Store new clauses for next iteration
        clauses = clauses + new
        # Store generated clauses in this iteration
        output.append(new)
            


if __name__ == "__main__":

    input_file = "Input.txt"
    output_file = "Output.txt"
    a_statement, kb = read_input(input_file)
    semantic, output = PL_Resolution(a_statement, kb) 
    write_output(output, output_file)


    # # Run two examples in the Input folder
    # for i in range(1, 3):
    #     input_file = "Input/example" + str(i) + ".txt"
    #     output_file = "example" + str(i) + "_output.txt"
    #     a_statement, kb = read_input(input_file)
    #     semantic, output = PL_Resolution(a_statement, kb)
    #     write_output(output, output_file)

    # # Run all test cases in Input folder
    # for i in range(1, 6):
    #     input_file = "Input/Input" + str(i) + ".txt"
    #     output_file = "Output" + str(i) + ".txt"
    #     a_statement, kb = read_input(input_file)
    #     semantic, output = PL_Resolution(a_statement, kb)
    #     write_output(output, output_file)
