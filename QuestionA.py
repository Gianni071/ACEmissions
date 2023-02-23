import numpy as np

import matplotlib.pyplot as plt
#Initial values
VMRinit = 10e-12 #-
rho_air = 1 #kg m^-3
Mair = 29 #kg/kmol
NA = 6.02e26 #molec/kmol
Vbox = 10**9 #m3
MN = 14 #kg/kmol

P = 0.004166666666666667 #kgN per hour
L = 0.9834714538 #per hour

#Production in molec/cm3/hr
Cprod = P*(10**-15)*(MN**-1)*NA
print(Cprod)
#Concentration of NOx in molec/cm^3:
Ci = VMRinit*(10**-6)*NA*rho_air*(Mair**-1)
print(Ci)

Carray = []
for i in range(1,721):
    if i<241:
        Ci = (Ci)/(1/L)
        Carray.append(Ci)
    else:
        Ci = (Ci+Cprod)/(1/L)
        Carray.append(Ci)

Carray = np.array(Carray)

Mboxarray = Carray*(10**15)*(1/NA)*MN

t = np.linspace(1,720,720)


plt.figure()
plt.plot(t,Mboxarray)
plt.xlabel("Time [hrs]")
plt.ylabel("$NO_x$ Concentration [kgN/box]")
plt.grid()
plt.show()