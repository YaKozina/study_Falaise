//calculating cuts for 0nuSe82
#include "./include/MiEvent.h"
#include <iostream>
R__LOAD_LIBRARY(./lib/libMiModule.so);

void Example_ROOT()
{
    TFile* f = new TFile("./testing_products/Default.root");  
    TTree* s = (TTree*) f->Get("Event");  // Отримуємо дерево з іменем "Event"
//  s->Print(); //get list of branches in Event

int N = s->GetEntries(); //total number of entries
int n_calos = 0; //number of calorimeter hits
int passed1 = 0; //number of events which match the criteria n_calos = 2

   MiEvent* Eve = new MiEvent();  
   s->SetBranchAddress("Eventdata", &Eve);  // Прив'язуємо гілку до об'єкта Eve

    for (UInt_t i = 0; i < N; i++) 
  {		
        s->GetEntry(i);  
        n_calos = Eve->getCD()->getnoofcaloh(); //getnoofcaloh is a public method in MiCD.h to get the number of calorimeter hits
        if (n_calos == 2) passed1++;

    }	
cout << endl << "EFFICIENCIES :" << endl;
cout << "eps1 = " << (100.0 * passed1) / N << "% +- "<< (100.0 * sqrt(double(passed1)) ) / N << "%" << endl;

}

