# CUFF vs TIME Electrode Comparison in COMSOL

## Project Overview

This project focuses on the computational comparison between two neural stimulation electrode configurations:

* **CUFF electrodes**
* **TIME electrodes** (Transverse Intrafascicular Multichannel Electrodes)
* **AIR electrodes**

The simulations are implemented in COMSOL Multiphysics in order to evaluate and compare the electrical stimulation behavior produced by the 3 electrode types when applied to peripheral nerve fascicles.

The main goal of the project is to investigate how the geometry and positioning of the electrodes influence:

* Electric potential distribution
* Selectivity of neural stimulation
* Fascicle recruitment
* Axonal activation

The project includes finite element simulations of the nerve environment together with neuronal activation analysis.

---
# Geometry and Nerve Structure

The geometries used in the simulations are generated and imported through the integration between MATLAB and COMSOL Multiphysics.

MATLAB is used to:

* Define parametric geometries
* Generate nerve and fascicle structures
* Control geometric dimensions and positioning
* Automate model configuration
* Simplify the creation of multiple simulation scenarios

The generated geometrical data are then transferred to COMSOL through the MATLAB-COMSOL interface, enabling automated model construction and simulation workflows.

The computational domain consists of a peripheral nerve immersed in a saline solution used to reproduce the interstitial biological environment.

* Saline conductivity: σ=2S/m

The nerve structure contains five fascicles with different dimensions distributed inside the nerve.

Each fascicle contains a neuron modeled through the Hodgkin–Huxley (HH) model in order to evaluate whether the applied electrical stimulation successfully excites the fascicle.

The biological tissues included in the model are:

Tissue	Conductivity
* Epineurium	σ=0.083S/m
* Endoneurium	σ={0.083, 0.083, 0.571}S/m
* Perineurium	Modeled as contact impedance, σ=0.0009S/m

The perineurium is modeled as a contact impedance layer to reproduce the insulating behavior surrounding each fascicle.
---

# CUFF Electrode Model

The CUFF electrode is modeled as an extraneural stimulation device wrapped around the nerve.

The electrodes are made of platinum with conductivity:

* Platinum conductivity: σ=9.4×10^6 S/m

The electrodes are mechanically fixed through a silicone cuff acting as insulating support material:

* Silicone conductivity: σ=1×10^−12 S/m

Different stimulation strategies are analyzed for the CUFF configuration, including:

- Monopolar stimulation
- Bipolar stimulation
- Tripolar stimulation
- Multipolar stimulation

The simulations are used to investigate electric potentiql penetration, current density distribution, fascicle selectivity, and stimulation efficiency.

---

# TIME Electrode Model



---
# AIR Electrode Model 


---

# Physics and Simulation Environment

The simulations are implemented using COMSOL Multiphysics.

The project mainly relies on:

* Electric Currents physics
* Conductive media modeling
* Finite Element Method (FEM)
* Time-dependent and stationary studies

The simulation workflow includes:

1. Geometry generation
2. Material assignment
3. Boundary condition definition
4. Mesh generation
5. Electrical stimulation setup
6. Solver execution
7. Axonal activation analysis

---


# Simulation Goals

The project aims to:

* Compare Cuff, TIME and AIR electrode performance
* Evaluate neural selectivity
* Analyze electric field propagation
* Study fascicle recruitment
* Investigate axonal activation thresholds
* Optimize stimulation strategies

---

