from typing import Callable, List

import numpy as np


def euler(
        *,
        x0: float,
        y0: float,
        z0: float,
        dt: float,
        t: float,
        sigma: float,
        rho: float,
        beta: float,
        X: np.ndarray,
        Y: np.ndarray,
        Z: np.ndarray,
        T: np.ndarray,
) -> None:
    """
    Perform Euler's method for solving the Lorenz system of differential equations.

    This function updates the provided arrays X, Y, Z, and T with the calculated
    values at each step of the Euler's method iteration, using the Lorenz system
    parameters (sigma, rho, beta) and initial conditions (x0, y0, z0).

    Parameters:
    - x0 (float): Initial value for the x-component of the system.
    - y0 (float): Initial value for the y-component of the system.
    - z0 (float): Initial value for the z-component of the system.
    - dt (float): The time increment for each step of the iteration.
    - t (float): The total time to iterate over (not used in the function as provided).
    - sigma (float): The sigma parameter in the Lorenz system.
    - rho (float): The rho parameter in the Lorenz system.
    - beta (float): The beta parameter in the Lorenz system.
    - X (np.ndarray): Array to be filled with the x-component values.
    - Y (np.ndarray): Array to be filled with the y-component values.
    - Z (np.ndarray): Array to be filled with the z-component values.
    - T (np.ndarray): Array to be filled with the time values at each step.

    Returns:
    None: This function updates the arrays in place and does not return any value.

    Note:
    This function assumes the arrays X, Y, Z, and T have been properly initialized
    and are of appropriate size to hold all the values for the timesteps computed.

    Example:
    >>> X = np.zeros(1000)
    >>> Y = np.zeros(1000)
    >>> Z = np.zeros(1000)
    >>> T = np.zeros(1000)
    >>> euler(
    ...     x0=0.0,
    ...     y0=1.0,
    ...     z0=1.05,
    ...     dt=0.01,
    ...     t=400.0,
    ...     sigma=10.0,
    ...     rho=28.0,
    ...     beta=8.0 / 3.0,
    ...     X=X,
    ...     Y=Y,
    ...     Z=Z,
    ...     T=T,
    )
    """
    X[0] = x0
    Y[0] = y0
    Z[0] = z0
    T[0] = 0.0
    for i in range(len(T) - 1):
        X[i + 1] = X[i] + dt * sigma * (Y[i] - X[i])
        Y[i + 1] = Y[i] + dt * (X[i] * (rho - Z[i]) - Y[i])
        Z[i + 1] = Z[i] + dt * (X[i] * Y[i] - beta * Z[i])
        T[i + 1] = T[i] + dt
    return
