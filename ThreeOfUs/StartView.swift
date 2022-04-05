//
//  StartView.swift
//  ThreeOfUs
//
//  Created by Orszagh Sandor on 2022. 04. 03..
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Three of Us")
                Spacer()

                NavigationLink(destination: ContentView(age:Age.kid), label:{
                            Text("Kid")
                    }).padding()

                
                NavigationLink(destination: ContentView(age:Age.adult), label:{
                        Text("Adult")
                    }).padding()
                    
                
                NavigationLink(destination: ContentView(age:Age.master), label:{
                        Text("Master")
                    }).padding()
                
                Spacer()
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
