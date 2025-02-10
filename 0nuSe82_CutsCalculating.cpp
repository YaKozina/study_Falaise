//calculating cuts for 0nuSe82//modified Example_ROOT.cpp script
#include "./include/MiEvent.h"
#include <iostream>
R__LOAD_LIBRARY(./lib/libMiModule.so);

void Example_ROOT()
{
    TFile* f = new TFile("Default.root");  
    TTree* s = (TTree*) f->Get("Event");  // get tree with name "Event"
    
int N = s->GetEntries();
int passed1 = 0;
int passed2 = 0;
int passed3 = 0;
int n_calos; //counter of calorimeter hits
int n_tracks; //counter of reconstructed tracks
int  negTracks; //counter of negative tracks

   MiEvent* Eve = new MiEvent();  
   s->SetBranchAddress("Eventdata", &Eve);  // Прив'язуємо гілку до об'єкта Eve
   n_calos = 0;
    for (UInt_t i = 0; i < N; i++) //the external loop for the total number of events
  {	
  
//2 calo hits	
        s->GetEntry(i);  
        n_calos = Eve->getCD()->getnoofcaloh(); //getnoofcaloh is a public method of MiCD.h 
        if (n_calos == 2) passed1++;
        
//???????        
//2 calo hits & 2 reconstructed tracks (& 2 reconstructed tracks)        
 vector<MiCDParticle>* particles = Eve->getPTD()->getpartv(); //MiPTD getpartv() - gives all particles??
  n_tracks = 0; // set the counter to 0 to make the loop work correctly
  negTracks = 0; // --//--

    for (size_t j = 0; j < particles->size(); j++) 
    {
        MiCDParticle* particle = &particles->at(j);
        
        // Вважаємо трек реконструйованим, якщо є хоча б 1 удар калориметр або вершина???
        //assume that track is reconstructed if there is at least 1 calorimeter hit or vertex
        //thus we can assume that the particle interacted with the detector -> there are such data as calo hit count or number of vertexes
 
        bool isReconstructed = !particle->getcalohitv()->empty() || !particle->getvertexv()->empty();

        if (isReconstructed) //for eps2 computation
        {
            n_tracks++; 
            if (particle->getcharge() < 0) //additional criteria (charge) for eps3 computation
            {
                negTracks++;
            }
        }
    }

    if (n_calos == 2 && n_tracks == 2) passed2++;
    if (n_calos == 2 && n_tracks == 2 && negTracks == 2) passed3++;
        
        
        
//drafts but still may be useful*************************************************************************************        
        //to get information about tracks we are going to read the length of vector getpartv() which contains info about
        //the number of particles so we we compare it to numer 2 which is the number of tracs we needed to satisfy the criteria of eps2   
//*        n_tracks = Eve->getPTD()->getpartv()->size();//getpartv() is a public method of MiPTD.h //getting size of the vector aka the number of particles



//2 calo hits & 2 reconstructed tracks	
//not sure if it is right way to calculate
//vector<MiCDParticle>* particles = Eve->getPTD()->getpartv(); 
//  int n_tracks=0;

//    for (size_t j = 0; j < particles->size(); j++) 
//    {
//        MiCDParticle* particle = &particles->at(j);
        
        // Вважаємо трек реконструйованим, якщо є хоча б 1 калориметричний хіт або вершина???
        //assume that track is reconstructed if there is at least 1 calorimeter hit or vertex
        //thus we can assume that the particle interacted with the detector -> there are such data as calo hit count or number of vertexes
 
//        if (particle->getcalohitv()->size() > 0 || particle->getvertexv()->size() > 0) n_tracks++; 
        
//    }
//        if (n_calos == 2 && n_tracks == 2) passed2++;
        
        
        
        //2 calo hits & 2 reconstructed tracks	end
        
//2 calo hits & 2 reconstructed tracks	& 2 negative tracks

//int negTracks = 0;
// n_tracks = 0; 
//    for (size_t j = 0; j < particles->size(); j++) {
//        MiCDParticle* particle = &particles->at(j);
//        bool isReconstructed = !particle->getcalohitv()->empty() || !particle->getvertexv()->empty();
//        if (isReconstructed && particle->getcharge() < 0) negTracks++;
     
//    }

//    if (negTracks == 2) passed3++;


//2 calo hits & 2 reconstructed tracks	& 2 negative tracks


//end of the drafts *************************************************

}
        
cout << endl << "EFFICIENCIES :" << endl;
cout << "eps1 = " << (100.0 * passed1) / N << "% +- "<< (100.0 * sqrt(double(passed1)) ) / N << "%" << endl;
cout << "eps2 = " << (100.0 * passed2) / N << "% +- "<< (100.0 * sqrt(double(passed2)) ) / N << "%" << endl;
cout << "eps3 = " << (100.0 * passed3) / N << "% +- "<< (100.0 * sqrt(double(passed3)) ) / N << "%" << endl;
}






