import numpy as np
from matplotlib import pyplot as plt
import euler
import parameters


def plot_lorenz(
    *,
    X: np.ndarray,
    Y: np.ndarray,
    Z: np.ndarray,
    T: np.ndarray,
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
    t: int = int(400 / 0.01)
    params = parameters.LorenzParameters(
        x0=0.0,
        y0=1.0,
        z0=1.05,
        dt=0.01,
        t=400.0,
        sigma=10.0,
        rho=28.0,
        beta=8.0 / 3.0,
        X=np.zeros(t),
        Y=np.zeros(t),
        Z=np.zeros(t),
        T=np.zeros(t),
    )

    euler.euler(**params)
    plot_lorenz(X=params.X, Y=params.Y, Z=params.Z, T=params.T)
