import pickle

import numpy as np
from matplotlib import pyplot as plt
from euler import euler
from euler import LorenzParameters


def plot_lorenz(
    *,
    X: np.ndarray,
    Y: np.ndarray,
    Z: np.ndarray,
) -> None:
    # Plotting the solution in 3D space
    fig = plt.figure()
    ax = fig.add_subplot(111, projection="3d")
    ax.plot(X, Y, Z, lw=0.5)
    ax.set_xlabel("X Axis")
    ax.set_ylabel("Y Axis")
    ax.set_zlabel("Z Axis")
    ax.set_title("Lorenz Attractor")

    plt.show()


if __name__ == "__main__":
    n: int = int(400 / 0.01)
    params = LorenzParameters(
        x0=1.0,
        y0=1.0,
        z0=1.0,
        dt=0.01,
        sigma=10.0,
        rho=28.0,
        beta=8.0 / 3.0,
        n=n,
    )
    X, Y, Z, T = euler(**params)
    plot_lorenz(X=X, Y=Y, Z=Z)
