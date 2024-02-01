import os
import argparse
import os

import numpy as np
from matplotlib import pyplot as plt

if __name__ == '__main__':
    # Write a parser to read in input from command line
    parser = argparse.ArgumentParser()
    parser.add_argument("--output_dir", type=str, default=os.getcwd())
    args = parser.parse_args()
    output_dir = args.output_dir
    s = []
    S = []
    with open(f"{output_dir}/output.txt", "r") as f:
        for line in f:
            s.append(line)
    for line in s:
        vec = line.split(' ')
        # remove all non-numeric characters
        vec = [float(i) for i in vec if '.' in i]
        S.append(vec)
    S = np.array(S)
    X = S[:, 0]
    Y = S[:, 1]
    Z = S[:, 2]
    fig = plt.figure()
    ax = fig.add_subplot(111, projection="3d")
    ax.plot(X, Y, Z, lw=0.5)
    ax.set_xlabel("X Axis")
    ax.set_ylabel("Y Axis")
    ax.set_zlabel("Z Axis")
    ax.set_title("Lorenz Attractor")

    plt.show()

    os.remove("output.txt")