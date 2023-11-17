import sys, os, shutil
import datetime
import json
import pickle
import subprocess as subproc
from functools import reduce

try:
    import numpy as np
    import scipy as sp
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    import pandas as pd
    import torch
except ImportError:
    pass

from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import HasFocus, ViInsertMode
from prompt_toolkit.key_binding.vi_state import InputMode

ipy = get_ipython()
ipy.run_line_magic("load_ext", "autoreload")
ipy.run_line_magic("autoreload","1")

q = exit

# nmap C-J <ESC>
def switch_to_navigation_mode(event):
   vi_state = event.cli.vi_state
   vi_state.input_mode = InputMode.NAVIGATION

if getattr(ipy, "pt_app", None):
   registry = ipy.pt_app.key_bindings
   registry.add_binding(Keys.ControlJ, filter=(HasFocus(DEFAULT_BUFFER)
       & ViInsertMode()))(switch_to_navigation_mode)

# I'm too stupid to check slicing and array-shape things interactively every time :(
li = list(range(10))
a = np.array([ [0, 1, 2], [10, 11, 12], [20, 21, 22], [30, 31, 32] ])
