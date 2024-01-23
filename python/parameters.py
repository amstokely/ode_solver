from dataclasses import dataclass
import numpy as np


@dataclass
class LorenzParameters(object):
    x0: float
    y0: float
    z0: float
    dt: float
    t: float
    sigma: float
    rho: float
    beta: float
    X: np.ndarray
    Y: np.ndarray
    Z: np.ndarray
    T: np.ndarray

    def keys(self):
        return self.__dict__.keys()

    def values(self):
        return self.__dict__.values()

    def items(self):
        return self.__dict__.items()

    def __getitem__(self, item):
        return self.__dict__[item]

    def __setitem__(self, key, value):
        self.__dict__[key] = value

    def __iter__(self):
        for key in self.keys():
            yield key
