# OptimizedRocket
This repository holds the source code for the BYU ME EN 575 optimization project done by Mark Anderson, Adam Jackson, and Spencer Stoltz.

# Project Objective
***"Minimize the mass of a two-stage rocket flying on a trajectory through the atmosphere and ultimately acheiving orbital velocity."***

# Project Roles
- **Spencer Stoltz**: calculate the thrust required by the rocket, in particular as the rocket changes mass during flight by consuming fuel and staging.
- **Mark Anderson**: calculate the drag on the rocket at subsonic and supersonic speeds through a standard atmosphere.
- **Adam Jackson**: combine thrust and drag calculations with the orientation of the rocket to create the trajectory.

# Repository Contents
- `docs/`: includes documentation and theory for the project
- `src/`: contains the source code for the project such that one can download the code and it will automatically work properly when run
- `test/`: a place to store temporary and permanent test files, code, and results. Some output produced from this code will be intentionally ignored to reduce the repository size
- `getRocketCode.m`: a script that adds all of the files within this repository to your MATLAB path so you can use any file in any folder without needing to be inside that folder
- `runOptimization.m`: the function that you can call (without arguments) to perform the optimization from start to finish.

# Overview of Calculations Performed

## Drag


## Thrust


## Trajectory


# Overview of Optimization Algorithms Implemented
## Our Objective Function
```
[mass] = getRocketMass(x0);
```
where x0 = [rocketLength,orientation_1, orientation_2,...,orientation_N]. The orientations are defined as angles away from the vertical. They are constrained such that the first orientation is 0 degrees (nose up) and the final orientation is 90 degrees (nose sideways).

# Reasoning for Other Methodological Decisions
- Why use MATLAB?
  - MATLAB provides a useful optimization toolbox that will enable us to use well-trusted optimizers. Additionally, our group is primarily experienced in MATLAB and decided that it would provide the fastest way to begin to produce results
