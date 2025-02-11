//calculating cuts 
#include "./include/MiEvent.h"
#include <iostream>
R__LOAD_LIBRARY(./libMiModule.so);

void Example_ROOT()
{
    TFile* f = new TFile("Default.root");  
    TTree* s = (TTree*) f->Get("Event");  // get tree with name "Event"
    

int N = s->GetEntries();
int passed1 = 0;
int passed2 = 0;
int passed3 = 0;
int passed4 = 0;
int n_calos; //counter of calorimeter hits
int n_tracks; //counter of reconstructed tracks
int  negTracks; //counter of negative tracks
double totalEnergy; //total calorimeter evergy counter

   MiEvent* Eve = new MiEvent();  
   s->SetBranchAddress("Eventdata", &Eve);  // Прив'язуємо гілку до об'єкта Eve
   n_calos = 0;
    for (UInt_t i = 0; i < N; i++) //the external loop for the total number of events
  {	
  
//2 calo hits
        s->GetEntry(i);  
        n_calos = Eve->getCD()->getnoofcaloh(); //getnoofcaloh is a public method of MiCD.h 
        if (n_calos == 2) passed1++;
        
      
//2 calo hits & 2 reconstructed tracks (& 2 reconstructed negative tracks)

//*to get information about tracks we are going to read the length of vector getpartv() which contains info about
//*the number of particles so we we compare it to numer 2 which is the number of tracs we needed to satisfy the criteria of eps2   
//*n_tracks = Eve->getPTD()->getpartv()->size();//getpartv() is a public method of MiPTD.h //getting size of the vector aka the number of particles

 vector<MiCDParticle>* particles = Eve->getPTD()->getpartv(); //MiPTD getpartv() - gives all particles number??
  n_tracks = 0; // set the counter to 0 to make the loop work correctly
  negTracks = 0; // --//--

    for (size_t j = 0; j < particles->size(); j++) 
    {
        MiCDParticle* particle = &particles->at(j);
        
        //*assume that track is reconstructed if there is at least 1 calorimeter hit or vertex
        //*thus we can assume that the particle interacted with the detector -> there are such data as calo 
        //*hit  count or number of vertexes
 
        bool isReconstructed = !particle->getcalohitv()->empty() || !particle->getvertexv()->empty();

        if (isReconstructed) //for eps2 computation
        {
            n_tracks++; 
            if (particle->getcharge() < 0) negTracks++; // minus charge criteria for eps3 computation - 2 calo hits & 2 reconstructed tracks	
            
        }
    }

    if (n_calos == 2 && n_tracks == 2) passed2++;
    if (n_calos == 2 && n_tracks == 2 && negTracks == 2) passed3++;
        
// total energy>2MeV & 2 calo hits & 2 reconstructed tracks & 2 reconstructed negative tracks
        totalEnergy = 0.0;
        for (int i = 0; i < Eve->getCD()->getnoofcaloh(); ++i) {
            MiCDCaloHit* caloHit = Eve->getCD()->getcalohit(i);
            totalEnergy += caloHit->getE();  // додаємо енергію кожного хіта
          //cout << "Event " << i << " Energy: " << totalEnergy << " MeV" << endl; //*not necessary but may be useful 
          //*to see the whole range of energies to adjust the energy filter criteria
        }

        if (n_calos == 2 && n_tracks == 2 && negTracks == 2 && totalEnergy >= 2000.0) passed4++;  //here energy is demonstrated in eV

}
          
    	
cout << endl << "EFFICIENCIES :" << endl;
cout << "eps1 = " << (100.0 * passed1) / N << "% +- "<< (100.0 * sqrt(double(passed1)) ) / N << "%" << endl;
cout << "eps2 = " << (100.0 * passed2) / N << "% +- "<< (100.0 * sqrt(double(passed2)) ) / N << "%" << endl;
cout << "eps3 = " << (100.0 * passed3) / N << "% +- "<< (100.0 * sqrt(double(passed3)) ) / N << "%" << endl;
cout << "eps4 = " << (100.0 * passed4) / N << "% +- "<< (100.0 * sqrt(double(passed4)) ) / N << "%" << endl;
}






