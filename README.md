[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=symbiotic-engineering/IFAC_CAMS_2024)

# Force Saturation Analysis

This repository can replicate the plots in the IFAC-CAMS paper, showing the effect of an impedance mismatch on electrical power production of a wave energy converter, and especially the effect of an impedance mismatch caused by nonlinear actuator force saturation.

Note that it is intended for showing relationships, and is not intended for real-time execution in an optimization. Optimization-suited code for the effect of force saturation on mechanical power exists [Here](https://github.com/symbiotic-engineering/MDOcean/blob/49bee41511abcb8873273ba0ff210978d67bb053/mdocean/simulation/modules/dynamics/dynamics.m#L90), and for the effect of force saturation on electrical power will be developed soon. 

Citation: McCabe and Haji, "Force-Limited Control of Wave Energy Converters using a Describing Function Linearization," IFAC Conference on Control Applications in Marine Systems, Robotics, and Vehicles 2024.

# How to replicate results
- Use `electrical_impedance_match.mlx` to derive equations 3, 4, and 5. This script also contains some plots that served as early inspiration for figures 2, 3, and 4.
- Use `elec_impedance_match_plots.m` to display figures 2, 3, and 4.
- Use [this](https://github.com/symbiotic-engineering/MDOcean/blob/main/mdocean/plots/sin_saturation_demo.m) script from another repository to display figure 6.
- Use `describing_fcn_fsat_graphs.mlx` to derive equation 16 and display figure 8.
- Use `sensitivity_plot.m` to display figure 9.

# Dependencies
- MATLAB (tested in R2023b)
- Symbolic math toolbox
- RF toolbox (for smith plots)
- the paretoFront function can be found [here](https://github.com/symbiotic-engineering/MDOcean/blob/main/mdocean/optimization/multiobjective/paretoFront.m)

# Funding Acknowledgement
This material is based upon work supported by the National Science Foundation Graduate Research Fellowship under Grant No. DGE–2139899. Any opinion, findings, and conclusions or recommendations expressed in this material are those of the authors(s) and do not necessarily reflect the views of the National Science Foundation.
