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
a = 1/L
b = a - 1
T = 293 #Kelvin

#Production in molec/cm3/hr
Cprod = P*(10**-15)*(MN**-1)*NA

#Concentration of NOx in molec/cm^3:
Ci = VMRinit*(10**-6)*NA*rho_air*(Mair**-1)

#Calculate concentrations
Carray = [Ci]
for i in range(1,721):
    if i<241:
        Ci = (Ci)/(1+b)
        Carray.append(Ci)
    else:
        Ci = (Ci+Cprod)/(1+b)
        Carray.append(Ci)

Carray = np.array(Carray)
#Convert to kgN per box
Mboxarray = Carray*(10**15)*(1/NA)*MN
t = np.linspace(0,720,721)
t = t/24 #Convert to days

#Plot figure
plt.figure("Question A")
plt.plot(t,Mboxarray,"r")
plt.xlabel("Time [days]")
plt.ylabel("$NO_x$ Concentration [kgN/box]")
plt.grid()
#plt.show()

## NOx Ratios

#Initial values
k1 = 3e-12 * np.exp(-1500/T)
k2 = 5e-3
k3 = 5.1e-12 * np.exp(210/T)
O3 = 45e-9 #ppbv
Ozoneratio = 5e-6

#Convert O3 concentration to molec/cm3
CO3 = (O3*rho_air*NA)/(Mair*(10**6))

NOtoNO2 = k2/(k1*CO3) + (k3/k1)*Ozoneratio
NOtoNOx = 1/(1+(1/NOtoNO2))


#Questions C and D
#Initial values
COprod = 12 #kg/day
CH4prod = 0.24 #kg/day
COinit = (140e-9) #mol/mol
CH4init = (1900e-9) #ppbv
O3init = (45e-9) #ppbv
OH = 1.5e6 #molec/cm3
HO2 = 450e6 #molec/cm3
cair = (NA*(1/(10**6)))/29
MCH4 = 16 #kg/kmol
MCO = 28 #kg/kmol
cOH = 1.5e6
cHO2 = 450e6

#VMR to C conversion
cCH4 = CH4init*rho_air*NA/(Mair*(10**6)) #molec/cm3
cO3 = O3init*rho_air*NA/(Mair*(10**6)) #molec/cm3
cCO = COinit*rho_air*NA/(Mair*(10**6)) #molec/cm3

#Production terms to molec/cm3 hr
COprod = COprod*NA/(24*MCO*Vbox*(10**6))
CH4prod = CH4prod*NA/(24*MCH4*Vbox*(10**6))

#Reaction Rate Constants (times 3600 to have rate per hour)
k4 = 3600*(1.57e-13)+cair*(3.54e-33) #cm3/molec*hr
k5 = 3600*(1.85e-20)*np.exp((2.82*np.log10(T)-987)/T)
k6 = 3600*(3.3e-12)*np.exp(270/T)
k7 = 3600*(1e-14)*np.exp(-490/T)
k8 = 3600*(1.7e-12)*np.exp(-940/T)

#Arrays for question C
cCOarray = [cCO]
cCH4array = [cCH4]
cO3array = [cO3]
cNOinit = NOtoNOx*Carray[0]
cNOarray = [cNOinit]

#Arrays for question D
cNOprod = []
cHO2loss = []
cOHloss = []
netO3prod = []



for i in range(1,721):
    if i<241:
        #CO concentration
        dCO = -k4*cCO*cOH
        cCO = cCO + dCO

        #CH4 concentration
        dCH4 = -k5*cCH4*cOH
        cCH4 = cCH4 + dCH4

        #NO concentration
        NOtoNO2 = k2 / (k1 * cO3) + (k3 / k1) * Ozoneratio
        NOtoNOx = 1 / (1 + (1 / NOtoNO2))
        cNO = NOtoNOx*Carray[i]
        cNOarray.append(cNO)

        #Ozone concentration
        dO3 = k6*cNO*cHO2 - k7*cO3*cHO2 - k8*cO3*cOH
        conHO2 = -k7*cO3*cHO2
        conOH = -k8*cO3*cOH
        conNO = k6*cNO*cHO2
        cO3 = cO3 + dO3

        #Append values
        cCOarray.append(cCO)
        cCH4array.append(cCH4)
        cO3array.append(cO3)
    else:
        # CO concentration
        dCO = -k4 * cCO * cOH + COprod
        cCO = cCO + dCO

        # CH4 concentration
        dCH4 = -k5 * cCH4 * cOH + CH4prod
        cCH4 = cCH4 + dCH4

        # NO concentration
        NOtoNO2 = k2 / (k1 * cO3) + (k3 / k1) * Ozoneratio
        NOtoNOx = 1 / (1 + (1 / NOtoNO2))
        cNO = NOtoNOx*Carray[i]
        cNOarray.append(cNO)

        # Ozone concentration
        dO3 = k6 * cNO * cHO2 - k7 * cO3 * cHO2 - k8 * cO3 * cOH
        conHO2 = -k7*cO3*cHO2
        conOH = -k8*cO3*cOH
        conNO = k6*cNO*cHO2
        cO3 = cO3 + dO3

        # Append values
        cCOarray.append(cCO)
        cCH4array.append(cCH4)
        cO3array.append(cO3)
        cHO2loss.append(conHO2)
        cNOprod.append(conNO)
        cOHloss.append(conOH)
        netO3prod.append(dO3)

#Convert lists to arrays
cCOarray = np.array(cCOarray)
cCH4array = np.array(cCH4array)
cO3array = np.array(cO3array)
cHO2loss = np.array(cHO2loss)
cHO2loss = cHO2loss/3600
cNOprod = np.array(cNOprod)
cNOprod = cNOprod/3600
cOHloss = np.array(cOHloss)
cOHloss = cOHloss/3600
netO3prod = np.array(netO3prod)
netO3prod = netO3prod/3600

#Plots for question C
#Convert arrays to required ppbv
COarray = (1e9)*cCOarray*((Mair*(10**6))/(rho_air*NA))
CH4array = (1e8)*cCH4array*((Mair*(10**6))/(rho_air*NA))
O3array = (1e10)*cO3array*((Mair*(10**6))/(rho_air*NA))
ppCarray = (1e12)*Carray*((Mair*(10**6))/(rho_air*NA))
print(O3array)




#Plot
plt.figure("Question C")
plt.plot(t,COarray,label="$CO$ [ppbv]")
plt.plot(t,CH4array,label="$CH_4$ [10 ppbv]" )
plt.plot(t,O3array,label="$O_3$ [0.1 ppbv]")
plt.plot(t,ppCarray,label="$NO_x$ [pptv]")
plt.xlabel("Time [days]")
plt.ylabel("Concentration [mol/mol]")
plt.legend()
plt.grid()

ppCarray2 = ppCarray[241:]
ppCarray2 = ppCarray2*(10**(-12))

#Plots for question D
plt.figure("Question D")
plt.xscale("log")
plt.plot(ppCarray2,netO3prod,label="Net $O_3$ production")
plt.plot(ppCarray2,cNOprod,label="$NO + HO_2 \Longrightarrow NO + OH + O_3$")
plt.plot(ppCarray2,cHO2loss,label="$O_3 + HO_2 \Longrightarrow 2O_2 + OH$")
plt.plot(ppCarray2,cOHloss,label="$O_3 + OH \Longrightarrow O_2 + HO_2$")
plt.xlabel("$NO_x$ Concentration [mol/mol]")
plt.ylabel("Production Rate [molec cm$^{-3}$ s$^{-1}$]")
plt.legend()
plt.grid()
plt.show()