
import numpy as np

print("LIME: I am at the module scope. Run only at first call")

def empty_function(STATE):
    return

def bar(STATE):
    # this code runs every function call.
    M = STATE.get("MICBIMP", np.nan)
    E = STATE.get("EICBIMP", np.nan)
    print("LIME_py0: ", M)
    print("LIME_py1: ", E)
    E = E + 1
    STATE["EICBIMP"] = E


