from euler import euler, data_files
import pickle
import numpy as np


def test_euler():
    test_files = data_files("test")
    X_control = np.load(test_files[0])
    Y_control = np.load(test_files[1])
    Z_control = np.load(test_files[2])
    params = pickle.load(open(test_files[3], "rb"))
    X, Y, Z, T = euler(**params)
    for _ in range(len(X)):
        assert X[_] == X_control[_]
        assert Y[_] == Y_control[_]
        assert Z[_] == Z_control[_]
