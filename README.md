[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=symbiotic-engineering/IFAC_CAMS_2024)
[![arXiv](https://img.shields.io/badge/arXiv-2409.02408-b31b1b.svg?style=flat)](https://arxiv.org/abs/2409.02408)

# Force Saturation Analysis

This repository can replicate the plots in the [IFAC-CAMS paper](https://doi.org/10.1016/j.ifacol.2024.10.093), showing the effect of an impedance mismatch on electrical power production of a wave energy converter, and especially the effect of an impedance mismatch caused by nonlinear actuator force saturation.

Note that it is intended for showing relationships, and is not intended for real-time execution in an optimization. Optimization-suited code for the effect of force saturation on mechanical power exists [Here](https://github.com/symbiotic-engineering/MDOcean/blob/49bee41511abcb8873273ba0ff210978d67bb053/mdocean/simulation/modules/dynamics/dynamics.m#L90), and for the effect of force saturation on electrical power will be developed soon. 

Citation: McCabe and Haji, "Force-Limited Control of Wave Energy Converters using a Describing Function Linearization," IFAC Conference on Control Applications in Marine Systems, Robotics, and Vehicles 2024. doi: 10.1016/j.ifacol.2024.10.093. IFAC-PapersOnLine vol 58, issue 20, p440-445.

BibTeX:
```
@article{mccabe_force-limited_2024,
	series = {15th {IFAC} {Conference} on {Control} {Applications} in {Marine} {Systems}, {Robotics} and {Vehicles} {CAMS} 2024},
	title = {Force-{Limited} {Control} of {Wave} {Energy} {Converters} using a {Describing} {Function} {Linearization}⁎},
	volume = {58},
	issn = {2405-8963},
	url = {https://www.sciencedirect.com/science/article/pii/S2405896324018482},
	doi = {10.1016/j.ifacol.2024.10.093},
	abstract = {Actuator saturation is a common nonlinearity. In wave energy conversion, force saturation conveniently limits drivetrain size and cost with minimal impact on energy generation. However, such nonlinear dynamics typically demand numerical simulation, which increases computational cost and diminishes intuition. This paper instead uses describing functions to approximate a force saturation nonlinearity as a linear impedance mismatch. In the frequency domain, the impact of controller impedance mismatch (such as force limit, finite bandwidth, or parameter error) on electrical power production is shown analytically and graphically for a generic nondimensionalized single degree of freedom wave energy converter in regular waves. Results are visualized with Smith charts. Notably, systems with a specific ratio of reactive to real mechanical impedance are least sensitive to force limits, a criteria which conflicts with resonance and bandwidth considerations. The describing function method shows promise to enable future studies such as large-scale design optimization and co-design.},
	number = {20},
	urldate = {2024-12-09},
	journal = {IFAC-PapersOnLine},
	author = {McCabe, Rebecca and Haji, Maha N.},
	month = jan,
	year = {2024},
	keywords = {Wave energy converters, linearization, constrained control, describing functions, impedance mismatch, nonlinear and optimal marine system control, systems with saturation},
	pages = {440--445},
}
```


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
