import os
import shutil
import tarfile
import tempfile
from importlib import resources
from pathlib import Path

from .euler import euler
from .parameters import LorenzParameters

def data_files(key: str) -> tuple:
    temp_dir = tempfile.mkdtemp()
    data_files_dict = dict(
        test="test.tar.gz",
    )
    cwd = Path.cwd()
    with resources.path("euler.data", data_files_dict[key]) as tarball_file:
        os.chdir(tarball_file.parent)
        tarball = tarfile.open(tarball_file)
        tarball_members = [tarball_file.parent / f.name for f in tarball.getmembers()]
        temp_files = [Path(temp_dir) / f.name for f in tarball_members]
        tarball.extractall()
        tarball.close()
        for tarball_member, temp_file in zip(tarball_members, temp_files):
            shutil.copy(tarball_member, temp_file)
            tarball_member.unlink()
    os.chdir(cwd)
    return (
        Path(temp_dir) / f"X.npy",
        Path(temp_dir) / f"Y.npy",
        Path(temp_dir) / f"Z.npy",
        Path(temp_dir) / f"params.pkl",
    )
