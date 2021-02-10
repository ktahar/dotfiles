import sys, os, shutil
import datetime
import json
import subprocess as subproc

import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
from functools import reduce

from IPython import get_ipython

ipy= get_ipython()
ipy.magic('load_ext autoreload')
ipy.magic('autoreload 1')

q = exit

plt.ion()
