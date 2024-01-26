import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

X = np.array([1, 1, 5, 5, 5, 5, 5, 8, 8, 10, 10, 10, 10,12, 14,14, 14, 15,15,15,15,15,15,18, 18,18,18,18,18,18,18,20,20,20,20,20,20,20,21,21,21,21,25,25,25,25,25,28,28,30,30,30])

plt.hist(X, bins=10,edgecolor='black', linewidth=1.2)
plt.show()