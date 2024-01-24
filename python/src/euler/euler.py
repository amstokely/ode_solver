from typing import Callable, List

import numpy as np


def euler(
        *,
        x0: float,
        y0: float,
        z0: float,
        dt: float,
        sigma: float,
        rho: float,
        beta: float,
        n: int,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """
    Perform Euler's method for solving the Lorenz system of differential equations.

    This function calculates and returns the values of the Lorenz system
    components (X, Y, Z) and the time values (T) at each step of the Euler's method
    iteration, using the Lorenz system parameters (sigma, rho, beta) and initial
    conditions (x0, y0, z0).

    Parameters:
    - x0 (float): Initial value for the x-component of the system.
    - y0 (float): Initial value for the y-component of the system.
    - z0 (float): Initial value for the z-component of the system.
    - dt (float): The time increment for each step of the iteration.
    - sigma (float): The sigma parameter in the Lorenz system.
    - rho (float): The rho parameter in the Lorenz system.
    - beta (float): The beta parameter in the Lorenz system.
    - n (float): The total number of steps used to solve the system.

    Returns:
    Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]: A tuple containing the
    arrays X, Y, Z, and T, which represent the x-component, y-component, z-component,
    and time values at each iteration step, respectively.
    """
    X: np.ndarray = np.zeros(n)
    Y: np.ndarray = np.zeros(n)
    Z: np.ndarray = np.zeros(n)
    T: np.ndarray = np.zeros(n)
    X[0] = x0
    Y[0] = y0
    Z[0] = z0
    T[0] = 0.0
    for i in range(len(T) - 1):
        X[i + 1] = X[i] + dt * sigma * (Y[i] - X[i])
        Y[i + 1] = Y[i] + dt * (X[i] * (rho - Z[i]) - Y[i])
        Z[i + 1] = Z[i] + dt * (X[i] * Y[i] - beta * Z[i])
        T[i + 1] = T[i] + dt
    return X, Y, Z, T
