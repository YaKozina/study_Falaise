# study_Falaise

Here are collected scripts and files I created while doing the very first steps in studying Falaise. This branch contains the following scripts: * 
* MiModule_DataCutCalc.cpp
* send_0nu.sh  

# MiModule_DataCutCalc.cpp 
is a script which provides data cuts for simulations corresponding to 4 criteria using MiModule which should lead to collecting the most appropriate data of bb-decay simulations.

* 1st criteria (very rough estimation): 

To assume that we detected bb-decay we should have 2 electrons detected. 

Electrons go towards the calorimeter and hit it. But only if 2 electrons hit the calorimiter we asuume that it is 1 event, if there was different number of electrons we don't count such events. So in the 1st approach we can say that we have bb-decay if there are 2 calorimiter hits, but at this point we don't care about what exact type of charged particles these 2 particles which we assume were electrons really are them - we are interested only at that fact that they were detected by the calorimiter.

* 2nd criteria (is auxiliary for the 3rd one; includes 1st one)
  
As soon as we detected 2 charged particles (at this point we still assume that they are electrons and don't care whether they can be different particles e.g. positrones), to develop the next estimation (3rd) we need information about tracking. 

If there are 2 charged particles, each of them has to have it's own track in the detector. 

To reconstruct the trajectory of the b-particles we need at least 2 points - A (point of emmision - vertex coordinate) and B (point of hitting towards calorimiter - calorimiter hitting coordinate). Point A is located at the source of b-particles - Se82 foils, and point B at the calorimiter.

For each event there should exist these 2 points - if they exist we can reconstruct the trajectory between, thus we have a track of the particle. If there exist only 1 of them we don't count such event. So in this estimation we count event as valod one only if there exist 2 reconstructed tracks for each particle.

* 3rd criteria (identifying the charge of the 2 particles from 1st criteria; includes criterias 1-2)

Now we would like to clarify what kind of charged partickles we detected by the caorimiter at the 1st step. To know this we should have information about the number of detected particles and whether we can reconstruct their tracks. If so, we can move forward and measure their charge.

If the charge of 2 detected particles which have 2 reconstructed tracks is < 0, we count this event as valid. If at least 1 out of 2 particles doesn't obey this, we don't concider such event as vslid.

* 4th criteria (electrons' energy limitation; includes criterias 1-3)

Thus the Q-value for bb-decay of Se82 is 2.9 MeV, we need to detect only the electrons which are emmited because of the decay. So by this cut we reject all the background processes with lower energies.    
  
