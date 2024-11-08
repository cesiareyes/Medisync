//
//  UserClasses.swift
//  Medisync
//
//  Created by Will Terry on 11/7/24.
//

import FirebaseDatabase
import SwiftUI

class userPatient {
    
    var symptoms: Array<String> = [];
    var healthConditions: Array<String> = [];
    
}

class Patient {
    
    var heartBeat: Int = 0;
    var bpTop: Int = 0;
    var bpBottom: Int = 0;
//var bloodPressure: String = "";
    
    init(heartBeat: Int, bpTop: Int, bpBottom: Int) {
        self.heartBeat = heartBeat
        self.bpTop = bpTop
        self.bpBottom = bpBottom
//self.bloodPressure = (String(bpTop) + "/" + String(bpBottom) + "mm Hg")
        
        }
        
}

var testPatient = Patient(heartBeat: 70, bpTop: 200, bpBottom: 80);

func createPatient(bpTop: Int, bpBottom: Int) -> String {
    let bloodPressure:String = (String(bpTop) + "/" + String(bpBottom) + "mm Hg")
    return bloodPressure
}

//print(createPatient(bpTop: testPatient.bpTop, bpBottom: testPatient.bpBottom))















class userDoctor {
    
}

class userLabTech {
    
}
