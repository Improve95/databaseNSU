import matplotlib.pyplot as plt
import networkx as nx
import random

def main():
    num_nodes = 30
    num_edges = 250
    seed = 123
    G = nx.gnm_random_graph(num_nodes, num_edges, seed)

    random.seed(seed)
    for u, v in G.edges():
        G[u][v]['weight'] = random.randint(100, 1000)

    adj_matrix = nx.to_numpy_array(G)
    matrixLen = adj_matrix.shape
    for i in range(matrixLen[0]):
        for j in range(matrixLen[0]):
            if (adj_matrix[i][j] == 0):
                adj_matrix[i][j] = 100000
            if (i == j):
                adj_matrix[i][j] = 0

    # for node in adj_matrix:
        # print(node)

    routes = set()
    for i in range(num_nodes):
        routesList = list(range(i + 1, num_nodes))
        for j in range(i + 1, num_nodes):
            randomIndex = random.randint(1, routesList.__len__()) - 1
            popIndex = routesList.pop(randomIndex)
            routes.add((i, popIndex))
        
    print(routes)
    print(routes.__len__())

    

    # pos = nx.spring_layout(G)
    # plt.figure(figsize=(8, 6))
    # nx.draw(G, pos, with_labels=True, node_color="lightblue", edge_color="gray", node_size=800, font_size=10)
    # edge_labels = {(u, v): G[u][v]['weight'] for u, v in G.edges()}
    # nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=10, font_color="red")
    # plt.title(f"Случайный граф G({num_nodes}, {num_edges}) с весами рёбер")
    # plt.show()

if __name__ == "__main__":
    main()