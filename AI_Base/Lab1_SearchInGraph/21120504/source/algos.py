import pygame
from const import *
from maze import SearchSpace
import math


def drawLine(sc:pygame.Surface, a,  b) -> None:
    pygame.draw.line(sc, WHITE, a.rect.center, b.rect.center, 3)
    # change the speed here
    pygame.time.delay(5)
    pygame.display.update()

def drawSolutionLine(g: SearchSpace, sc: pygame.Surface, goal, fathers):
    goal.set_color(PURPLE, sc)
    count = 0
    current = goal.id
    while current != g.start.id:
        count += 1
        father = fathers[current]
        drawLine(sc, g.grid_cells[current], g.grid_cells[father])
        # trace back to the start node
        current = father
    print('Number of nodes in solution: ', count)
    # draw the start node
    g.grid_cells[current].set_color(ORANGE, sc)



def DFS(g: SearchSpace, sc: pygame.Surface):
    print('Implement DFS algorithm')

    open_set = [g.start.id]
    closed_set = []
    father = [-1]*g.get_length()

    # DFS algorithm using open_set as a stack
    while len(open_set) > 0:
        # pop the last element of the open_set
        current_node_id = open_set.pop()
        current_node = g.grid_cells[current_node_id]
        current_node.set_color(YELLOW, sc)
        
        # stop and draw the solution if the current node is the goal
        if g.is_goal(current_node):
            drawSolutionLine(g, sc, current_node, father)
            return
  
        # explore the neighbors of the current node
        neighbors = g.get_neighbors(current_node)

        for neighbor in neighbors:
            if (neighbor.id not in open_set) and (neighbor.id not in closed_set):
                # store the father of the neighbor to draw the solution later
                father[neighbor.id] = current_node.id
                open_set.append(neighbor.id)
                neighbor.set_color(RED, sc)

        closed_set.append(current_node.id)
        current_node.set_color(BLUE, sc)




def BFS(g: SearchSpace, sc: pygame.Surface):
    print('Implement BFS algorithm')
    
    open_set = [g.start.id]
    closed_set = []
    father = [-1]*g.get_length()

    # BFS using open_set as a queue
    while len(open_set) > 0:
        # pop the first element of the open_set
        current_node_id = open_set.pop(0)
        current_node = g.grid_cells[current_node_id]
        current_node.set_color(YELLOW, sc)

        if g.is_goal(current_node):
            drawSolutionLine(g, sc, current_node, father)
            return

        # explore the neighbors of the current node
        neighbors = g.get_neighbors(current_node)

        for neighbor in neighbors:
            if (neighbor.id not in open_set) and (neighbor.id not in closed_set):
                # store the father of the neighbor to draw the solution later
                father[neighbor.id] = current_node.id
                open_set.append(neighbor.id)
                neighbor.set_color(RED, sc)

        closed_set.append(current_node.id)
        current_node.set_color(BLUE, sc)

    # raise NotImplementedError('not implemented')

def UCS(g: SearchSpace, sc: pygame.Surface):
    print('Implement UCS algorithm')

    # +1 respect if you can implement UCS with a priority queue

    open_set = [g.start.id]
    closed_set = []
    father = [-1]*g.get_length()
    cost = [100_000]*g.get_length()
    cost[g.start.id] = 0

    while len(open_set) > 0:
        # Sort the open_set by the cost of the nodes --> move the lowest cost node to the front
        open_set.sort(key=lambda x: cost[x])
        current_node_id = open_set.pop(0)
        current_node = g.grid_cells[current_node_id]
        current_node.set_color(YELLOW, sc)

        if g.is_goal(current_node):
            drawSolutionLine(g, sc, current_node, father)
            print('Solution cost: ', cost[current_node.id])
            return
        
        # explore the neighbors of the current node
        neighbors = g.get_neighbors(current_node)

        for neighbor in neighbors:
            # Calculate the cost to move to the neighbor
            # 1 if the neighbor is a direct neighbor of the current node
            # sqrt(2) if the neighbor is a diagonal neighbor of the current node
            tentative_cost = 0
            if abs(neighbor.id - current_node.id) == 1 or abs(neighbor.id - current_node.id) == COLS:
                tentative_cost = cost[current_node.id] + 1
            else: 
                tentative_cost = cost[current_node.id] + math.sqrt(2)

            if (neighbor.id not in open_set) and (neighbor.id not in closed_set):
                father[neighbor.id] = current_node.id
                cost[neighbor.id] = tentative_cost
                open_set.append(neighbor.id)
                neighbor.set_color(RED, sc)

            elif neighbor.id in open_set:
                if cost[neighbor.id] > tentative_cost:
                    # neighbor is already in the open_set but we found a better path
                    # replace the father and the cost of the neighbor
                    cost[neighbor.id] = tentative_cost
                    father[neighbor.id] = current_node.id

        closed_set.append(current_node.id)
        current_node.set_color(BLUE, sc)







 
    # raise NotImplementedError('not implemented')

# Implement the heuristic function
def DiagonalDistance(current_node, goal):

    current_node_id = current_node.id
    goal_id = goal.id

    current_node_x = current_node_id % COLS
    current_node_y = current_node_id // COLS

    goal_x = goal_id % COLS
    goal_y = goal_id // COLS

    D1 = 1 # cost to move to a direct neighbor
    D2 = math.sqrt(2) # cost to move to a diagonal neighbor

    dx = abs(current_node_x - goal_x)
    dy = abs(current_node_y - goal_y)

    return D1*(dx + dy) + (D2 - 2*D1) *min(dx, dy)

def AStar(g: SearchSpace, sc: pygame.Surface):
    print('Implement AStar algorithm')

    # +1 respect if you can implement AStar with a priority queue

    open_set = [g.start.id]
    closed_set = []
    father = [-1]*g.get_length()
    cost = [100_000]*g.get_length()
    cost[g.start.id] = 0

    while len(open_set) > 0:
        # Sort the open_set by the cost and the heuristic of the nodes --> move the node with the lowest (cost + heuristic) to the front
        # Using DiagonalDistance as the heuristic because the agent can move in 8 directions
        open_set.sort(key=lambda x: cost[x] + DiagonalDistance(g.grid_cells[x], g.goal))

        current_node_id = open_set.pop(0)
        current_node = g.grid_cells[current_node_id]
        current_node.set_color(YELLOW, sc)


        if g.is_goal(current_node):
            drawSolutionLine(g, sc, current_node, father)
            print('Solution cost: ', cost[current_node.id])
            return

        neighbors = g.get_neighbors(current_node)

        for neighbor in neighbors:
            # Calculate the cost to move to the neighbor
            # 1 if the neighbor is a direct neighbor of the current node
            # sqrt(2) if the neighbor is a diagonal neighbor of the current node
            tentative_cost = 0
            if abs(neighbor.id - current_node.id) == 1 or abs(neighbor.id - current_node.id) == COLS:
                tentative_cost = cost[current_node.id] + 1
            else:
                tentative_cost = cost[current_node.id] + math.sqrt(2)
            
            if (neighbor.id not in open_set) and (neighbor.id not in closed_set):
                father[neighbor.id] = current_node.id
                cost[neighbor.id] = tentative_cost
                open_set.append(neighbor.id)
                neighbor.set_color(RED, sc)

            elif neighbor.id in open_set:
                # Because in the same node, the heuristic is the same we only need to compare the cost
                if cost[neighbor.id] > tentative_cost:
                    # neighbor is already in the open_set but we found a better path
                    # replace the father and the cost of the neighbor
                    cost[neighbor.id] = tentative_cost
                    father[neighbor.id] = current_node.id

        closed_set.append(current_node.id)
        current_node.set_color(BLUE, sc)

    # raise NotImplementedError('not implemented')

def EuclideanDistance(current_node, goal):
    
        current_node_id = current_node.id
        goal_id = goal.id
    
        current_node_x = current_node_id % COLS
        current_node_y = current_node_id // COLS
    
        goal_x = goal_id % COLS
        goal_y = goal_id // COLS
    
        dx = abs(current_node_x - goal_x)
        dy = abs(current_node_y - goal_y)
    
        return math.sqrt(dx**2 + dy**2)

def Greedy(g: SearchSpace, sc: pygame.Surface):
    print('Implement Greedy algorithm')

    open_set = [g.start.id]
    closed_set = []
    father = [-1]*g.get_length()

    while len(open_set) > 0:
        # Sort the open_set by the heuristic of the nodes --> move the node with the lowest heuristic to the front
        # Using DiagonalDistance as the heuristic
        open_set.sort(key=lambda x: EuclideanDistance(g.grid_cells[x], g.goal))

        current_node_id = open_set.pop(0)
        current_node = g.grid_cells[current_node_id]
        current_node.set_color(YELLOW, sc)


        if g.is_goal(current_node):
            drawSolutionLine(g, sc, current_node, father)
            return

        neighbors = g.get_neighbors(current_node)

        for neighbor in neighbors:
            if (neighbor.id not in open_set) and (neighbor.id not in closed_set):
                father[neighbor.id] = current_node.id
                open_set.append(neighbor.id)
                neighbor.set_color(RED, sc)

        closed_set.append(current_node.id)
        current_node.set_color(BLUE, sc)

    # raise NotImplementedError('not implemented'