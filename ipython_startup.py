import sys, os, shutil
import datetime
import json
import subprocess as subproc

import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd

from IPython import get_ipython
ipython = get_ipython()
ipython.magic('load_ext autoreload')
ipython.magic('autoreload 1')

plt.ion()
q = exit

if "SUMO_HOME" in os.environ:
    if os.path.join(os.environ["SUMO_HOME"], "tools") not in sys.path:
        sys.path.append(os.path.join(os.environ["SUMO_HOME"], "tools"))
