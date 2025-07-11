Here are collected scripts and files I created while doing the very first steps in studying Falaise. This branch contains the following scripts: 
* MiModule_DataCutCalc.cpp
* send_0nu.sh  

In this file you can find a detailed description of them.

# MiModule_DataCutCalc.cpp 
is a script which provides data cuts for simulations corresponding to 4 criteria using MiModule which should lead to collecting the most appropriate data of bb-decay simulations.

* 1st criterion (very rough estimation): 

To assume that we have detected a double beta decay (ββ-decay), we should detect 2 electrons.

Electrons go toward the calorimeter and hit it. So, in this approach, we say that we have a ββ-decay if there are 2 calorimeter hits. Only if 2 electrons hit the calorimeter, we assume that it corresponds to 1 event. If a different number of electrons hit the calorimeter, we do not count such events.

At this point, we do not care about the exact type of detected charged particles — we are only interested in the fact that 2 charged particles (assumed to be electrons) hit the calorimeter.

* 2nd criterion (is auxiliary for the 3rd one; includes 1st one)
  
As soon as we detect 2 charged particles (still assumed to be electrons), to develop the next criteria (the 3rd), we need information about tracking.

If there are 2 charged particles, each of them must have it's own track in the detector. 

To reconstruct the trajectory of the β-particles, we need at least two points: 

Point A — the emission point (vertex coordinate), located at the Se-82 foil (the source)
Point B — the calorimeter hit point.

For each event there should exist these 2 points - if both A and B exist for a particle, we can reconstruct its trajectory, thus we have a track of the particle. If there exist only 1 of them we don't count such event. 
So in this estimation we count event as valod one only if there exist 2 reconstructed tracks for each particle.

* 3rd criterion (identifying the charge of the 2 particles from 1st criteria; includes criterias 1-2)

Now we would like to identify what kind of charged particles we detected in the 1st step.
To do that, we need to know the number of detected particles and whether we can reconstruct their tracks (criteria 1 and 2). If so, we can move forward and measure their charge.

If the charges of both detected particles (with reconstructed tracks) are less than 0 (i.e. negative), we count this event as valid. If at least 1 of the 2 particles does not satisfy this condition, we do not consider such an event valid.

* 4th criterion (electrons' energy limitation; includes criterias 1-3)
  
Since the Q-value for ββ-decay of Se-82 is approximately 2.9 MeV, we are only interested in detecting electrons emitted due to this decay. Therefore, by applying this cut, we reject all background processes with lower energies.
