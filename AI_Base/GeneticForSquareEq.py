import numpy as np
import random

rand = np.random.RandomState()
# Define the equation to solve
def equation(x):
    return x**2 - 4*x + 3

# Decoding 32 bit chromosome to float in range [-100, 100]
def decoding(x):
    return -100 + x * 200 / (2**16 - 1)


def fitness(x):
    return  (1.0/(np.abs(equation(x)) + 0.001)).prod() + (np.abs(x[0] - x[1]))/10e4

# Define the geneticstandard algorithm parameters
population_size = 150
mutation_rate = 0.001
crossover_rate = 0.70
generations = 300

# Create the initial population (couple of 16 bit chromosomes)
population = np.array([np.array([rand.randint(0, 2**16 - 1), rand.randint(0, 2**16 - 1)]) for i in range(population_size)])


fitness_tracking = []
# Start the evolution loop
for generation in range(generations):
    # Calculate the fitness of the current population
    fitness_population = np.zeros(population_size)
    for i in range(population_size):
        fitness_population[i] = fitness(decoding(population[i]))
        
    fitness_tracking.append(fitness_population.sum())
    # Create the next generation
    new_population = np.zeros((population_size, 2), dtype=np.int64)
    for i in range(0, population_size, 2):
        # Select the parents with probability according to their fitness
        parent1 = random.choices(population, weights=fitness_population/fitness_population.sum())[0]
        parent2 = random.choices(population, weights=fitness_population/fitness_population.sum())[0]

        # Perform crossover and mutation
        #Combine two 16 bit chromosomes into one 32 bit chromosome
        parent1 = np.binary_repr(parent1[0], width=16) + np.binary_repr(parent1[1], width=16)
        parent2 = np.binary_repr(parent2[0], width=16) + np.binary_repr(parent2[1], width=16)

        # Crossover
        if rand.random() <= crossover_rate:
            # Randomly select a segment to crossover
            begin_segment = rand.randint(0, 31)
            end_segment = rand.randint(begin_segment + 1, 32)
            # Create the new chromosomes from the parents
            child1 = parent1[:begin_segment] + parent2[begin_segment:end_segment] + parent1[end_segment:]
            child2 = parent2[:begin_segment] + parent1[begin_segment:end_segment] + parent2[end_segment:]
        else:
            child1 = parent1
            child2 = parent2


        # Mutation for child1
        if rand.random() <= mutation_rate:
            # Randomly select a bit to flip
            bit_to_flip = rand.randint(0, 30)
            # Flip the bit
            if child1[bit_to_flip] == '0':
                child1 = child1[:bit_to_flip] + '1' + child1[bit_to_flip+1:]
            else:
                child1 = child1[:bit_to_flip] + '0' + child1[bit_to_flip+1:]
            
        # Mutation for child2
        if rand.random() <= mutation_rate:
            # Randomly select a bit to flip
            bit_to_flip = rand.randint(0, 31)
            # Flip the bit
            if child2[bit_to_flip] == '0':
                child2 = child2[:bit_to_flip] + '1' + child2[bit_to_flip+1:]
            else:
                child2 = child2[:bit_to_flip] + '0' + child2[bit_to_flip+1:]

        # Add the new chromosomes to the population 
        # Convert back to two 16 bit chromosomes
        child1 = np.array([int(child1[:16], 2), int(child1[16:], 2)])
        child2 = np.array([int(child2[:16], 2), int(child2[16:], 2)])
        new_population[i] = child1
        new_population[i+1] = child2

    
    
    population = new_population

# Print 2 best solutions
fitness_population = np.zeros(population_size)
for i in range(population_size):
    fitness_population[i] = fitness(decoding(population[i]))
solution = population[np.argmax(fitness_population)]

print("Best solution: ", decoding(solution), "Fitness: ", fitness(decoding(solution)))

# Plot the fitness through the generations
import matplotlib.pyplot as plt
plt.plot(fitness_tracking)
plt.xlabel('Generation')
plt.ylabel('Fitness')
plt.show()

 