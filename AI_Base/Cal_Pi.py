import numpy as np
import pandas as pd

rand = np.random.RandomState()

def calPi(N: int):
    data = pd.DataFrame({'x': rand.rand(N),
                         'y': rand.rand(N)})
    
    n = data.query('(x - 0.5)**2 + (y - 0.5)**2 <= 0.25').shape[0]

    Pi = 4 * (n/N)

    return Pi 

N = 10

while True:
    print(f'N: {N}')
    Pi = calPi(N)
    print(f'Pi: {Pi}')
    res = np.allclose(Pi, np.pi)
    print(res)
    if res:
        break
    else:
        N *= 10

