
from setuptools import find_packages
from setuptools import setup
import os

path = os.path.relpath(os.path.dirname(__file__))

setup(
    author='Andy Stokely',
    name='euler',
    install_requires=[],
    platforms=['Linux',
               'Unix', ],
    python_requires="<=3.9",
    
    package_dir={'': 'src'},
    packages=find_packages(where='src'),
    requires=["numpy", "pytest", "matplotlib"],
    zip_safe=False,
    package_data={
        'euler': [
            'data/*',
            ],
    },
)
