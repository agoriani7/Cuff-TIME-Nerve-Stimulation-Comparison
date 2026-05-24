# CUFF vs TIME Electrode Comparison in COMSOL

## Project Overview

This project focuses on the computational comparison between two neural stimulation electrode configurations:

* **CUFF electrodes**
* **TIME electrodes** (Transverse Intrafascicular Multichannel Electrodes)
* **AIR electrodes** (Adaptable Intrafascicular Radial Electrode)

The simulations are implemented in COMSOL Multiphysics 6.4 in order to evaluate and compare the electrical stimulation behavior produced by the 3 electrode types when applied to peripheral nerve fascicles.

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

* Saline conductivity: σ = 2 S/m

The nerve structure contains five fascicles with different dimensions distributed inside the nerve.

Each fascicle contains a neuron modeled through the Hodgkin–Huxley (HH) model in order to evaluate whether the applied electrical stimulation successfully excites the fascicle.

The biological tissues included in the model are:

Tissue	Conductivity
* Epineurium	σ = 0.083 S/m
* Endoneurium	σ = {0.083, 0.083, 0.571} S/m
* Perineurium	modeled as contact impedance, σ = 0.0009 S/m

The perineurium is modeled as a contact impedance layer to reproduce the insulating behavior surrounding each fascicle.

---
# CUFF Electrode Model

The CUFF electrode is modeled as an extraneural stimulation device wrapped around the outer surface of the nerve.

The electrode contacts are made of platinum with conductivity:

* Platinum conductivity: σ = 9.43×10^6 S/m

The insulating support structure is made of silicone with conductivity:

* Silicone conductivity: σ = 1×10^−12 S/m

The CUFF electrode is positioned concentrically around the epineurium without penetrating the neural tissue.

The active stimulation sites consist of:

Platinum active sites:
- Number of contacts: 8
- Width: 0.05 mm
- Length: 0.5 mm

The platinum contacts are positioned circumferentially on the inner surface of the cuff facing the epineurium.

---
# TIME Electrode Model

The TIME electrode is modeled as a transverse intrafascicular stimulation device inserted inside the nerve tissue.

The electrode substrate is made of polyimide acting as insulating support material:

* Polyimide conductivity: σ = 1×10^−14 S/m

The active stimulation sites are made of platinum with conductivity:

* Platinum conductivity: σ = 9.43×10^6 S/m

The TIME electrode is positioned transversally within the nerve and partially penetrates the epineurium and endoneurium without crossing the entire nerve structure.

The electrode geometry consists of:

Polyimide shank:
- Thickness: 20 µm
- Height: 280 µm
Platinum active sites:
- Number of contacts: 10
- Contact diameter: 60 µm
- Contact thickness: 300 nm

---
# AIR Electrode Model 


---
# Physics and Simulation Environment

The simulations are implemented using COMSOL Multiphysics 6.4.

The project mainly relies on:

* Electric Currents physics
* Conductive media modeling
* Finite Element Method (FEM)
* Stationary and time-dependent studies

The simulation workflow includes:

1. Geometry generation
2. Material assignment
3. Boundary and domain condition definition
4. Mesh generation
5. Electrical stimulation setup
6. Solver execution
7. Axonal activation analysis

---


# Simulation Goals

The project aims to:

* Compare Cuff, TIME and AIR electrode performance
* Evaluate neural selectivity
* Study fascicle recruitment
* Investigate axonal activation thresholds
* Optimize stimulation strategies

---

