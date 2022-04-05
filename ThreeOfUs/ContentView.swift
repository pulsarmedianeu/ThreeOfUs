//
//  ContentView.swift
//  ThreeOfUs
//
//  Created by Orszagh Sandor on 2022. 03. 29..
//

import SwiftUI
import CoreData

enum BtnState : Int {
    case none = 0
    case selected = 1
    case closed = 2
}

enum Age : Int {
    case kid = 0
    case adult = 1
    case master = 2
}

struct ContentView: View {
    
    
    var items: [GridItem] {
        Array(repeating: .init(.flexible(minimum: 100, maximum: 200)), count: 3 )
    }
    
    var age : Age = Age.kid
    

    
    @State var btnArr = [1,2,3,4,5,6,7,8,9,10,11,12]
    @State var btnStateArr = Array<BtnState>(repeating: BtnState.none, count: 12)
    @State var answerIndexArr : [Int?] = [nil,nil,nil]
    @State var heartNumber = 3
    @State var Level = 1
    @State var placeHolder = "?"
    @State var idx = 0
    @State var countPMatch = 0
    @State var pointNum : Int = 0
    
    //--> Alert
   
    @State var messagePopUp = "?"
    @State var titlePopUp = "?"
    @State var systemNamePopUp = "xmark.circle.fill"
    @State var buttonPopUp = "Ok"
    @State var showPopUp : Bool = false
    
    

    var body: some View {
        ZStack{
                VStack{
                    HStack {
                        Text("Level \(Level)")
                        Spacer()
                        Text("Difficulty: \(age.rawValue)")
                        Spacer()
                        Text("Point: \(pointNum)")
                        Spacer()
                        HStack {
                            Image(systemName: "heart").foregroundColor(heartNumber > 0 ?  Color.red : Color.black)
                            Image(systemName: "heart").foregroundColor(heartNumber > 1 ?  Color.red : Color.black)
                            Image(systemName: "heart").foregroundColor(heartNumber == 3 ?  Color.red : Color.black)
                        }
                    } .padding()
                    Spacer()
                    HStack {
                        
                        Text("\(answerIndexArr[0] != nil ? String(btnArr[answerIndexArr[0]!]) : placeHolder)")
                        Text(" + ")
                        Text("\(answerIndexArr[1] != nil ? String(btnArr[answerIndexArr[1]!]) : placeHolder)")
                        Text(" = ")
                        Text("\(answerIndexArr[2] != nil ? String(btnArr[answerIndexArr[2]!]) : placeHolder)")
                        
                        Button("Clean") {
                            
                            answerIndexArr.forEach({ i in
                                if let id = i {
                                    btnStateArr[id] = BtnState.none
                                }
                            })
                            
                            idx = 0
                            
                        }.padding()
                    }
                    Spacer()
                    
                    LazyVGrid(columns:items,spacing: 30) {
                        ForEach(0..<12) { index in
                            
                            Button(String(btnArr[index])) {
                                
                                if idx < 3 {
                                    if btnStateArr[index] == BtnState.none {
                                        btnStateArr[index] = BtnState.selected
                                        answerIndexArr[idx] = index
                                        idx = idx + 1
                                    }
                                }
                                if idx == 3 {
                                    if checkAnswer(btnArrl: btnArr, indexArr: answerIndexArr) {
                                        
                                        titlePopUp = "Right Answer! Great!"
                                        messagePopUp = "Congratulation!"
                                        buttonPopUp = "OK"
                                        showPopUp = true
                                        
                                        answerIndexArr.forEach { i in
                                            btnStateArr[i!] = BtnState.closed
                                        }
                                     
                                        idx = 0

                                        // CheckPossible Match
                                        let countPMatch = countPossibleMatch(btnArr: btnArr, btnStateArr: btnStateArr)
                                        
                                        if countPMatch == 3 { pointNum = pointNum + 1 }
                                        if countPMatch == 2 { pointNum = pointNum + 2 }
                                        if countPMatch == 1 { pointNum = pointNum + 5 }
                                        
                                        if countPMatch == 0 {
                                            
                                            titlePopUp = "VÉGE"
                                            messagePopUp = "VÉGE"
                                            buttonPopUp = "OK"
                                            showPopUp = true
                                            
                                            answerIndexArr = clearAnswerIndx()
                                            btnStateArr = clearButtonState()
                                            btnArr = createNewQuiz(age: Age.kid, level: Level)
                                            Level = Level + 1
                                            pointNum = pointNum + 25
                                        }
                                        
                                        pointNum = pointNum + 10
                                        
                                        if (pointNum % 100 == 0) { Level = Level + 1}
                                        
                                    } else {
                                       
                                       titlePopUp = "Wrong Answer! Sorry!"
                                       messagePopUp = "Try to find again a Three of Us"
                                        buttonPopUp = "OK"
                                       showPopUp = true
                                       
                                       answerIndexArr.forEach { i in
                                           btnStateArr[i!] = BtnState.none
                                       }
                                       answerIndexArr = [nil,nil,nil]
                                       idx = 0
                                        
                                        heartNumber = heartNumber-1
                                        if heartNumber == 0 {
                                            
                                            titlePopUp = "GAME OVER"
                                            messagePopUp = "Try Again"
                                            buttonPopUp = "OK"
                                            showPopUp = true
                                            
                                            heartNumber = 3
                                            answerIndexArr = clearAnswerIndx()
                                            btnStateArr = clearButtonState()
                                            btnArr = createNewQuiz(age: Age.kid, level: Level)
                                            Level = 1
                                            pointNum = 0
                                        }
                                    }
                                }
                            }
                            .frame(width: 100, height: 100, alignment: Alignment.center)
                            .background((btnStateArr[index] == BtnState.none) ? Color.yellow : (btnStateArr[index] == BtnState.selected) ? Color.red : Color.gray)
                            .font(Font.largeTitle)
                        }
                    }
                    Spacer()
                }.onAppear {
                    answerIndexArr = clearAnswerIndx()
                    btnStateArr = clearButtonState()
                    btnArr = createNewQuiz(age: age, level: Level)
                }.navigationBarHidden(true)
                
                PopUpWindow(title:titlePopUp,message: messagePopUp,systemName: systemNamePopUp, buttonText: buttonPopUp,show:$showPopUp)
            }
        }
    }



extension Array {
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}


// ********************************************************************************
//-->>>FUNCs

func clearButtonState()->[BtnState] {
    
    return Array<BtnState>(repeating: BtnState.none, count: 12)
}

func clearAnswerIndx()->[Int?] {
    return [nil,nil,nil]
}

func clearIdx()->Int {
    return 0
}

func checkAnswer(btnArrl: [Int] , indexArr: [Int?])->Bool {
    
    guard indexArr.map({$0 != nil}).count == 3 else {
        return false
    }

    return (btnArrl[indexArr[0]!] + btnArrl[indexArr[1]!]) == btnArrl[indexArr[2]!]
}



func countPossibleMatch(btnArr:[Int], btnStateArr:[BtnState] )->Int {
    
    let permutations = PulsarMath.Permutations.getPermutations3from12()
    
    var count = 0
    permutations.forEach { permutation3 in
        
        let p1 = permutation3[0]
        let p2 = permutation3[1]
        let p3 = permutation3[2]
        
        let state1 = btnStateArr[p1]
        let state2 = btnStateArr[p2]
        let state3 = btnStateArr[p3]

        let v1 = btnArr[p1]
        let v2 = btnArr[p2]
        let v3 = btnArr[p3]
        
        if (state1 != BtnState.closed) && (state2 != BtnState.closed) && (state3 != BtnState.closed) {
            
            if (v1+v2==v3) || (v1+v3==v2) || (v2+v3==v1) {
                count = count + 1
            }
        }
    }
    return count
}



func createNewQuiz(age : Age, level : Int)->[Int] {
    
    var quiz : [Int] = []
    
    var range = Range(0...9)
    
    switch age {
        
        case Age.kid: range = Range(0...9+Int(level/4))
        case Age.adult: range = Range(Int(level/2)...99)
        case Age.master: range = Range((level*5)...999)
        
    }

    
    for _ in 0...3 {
        
        let a = Int.random(in:range)
        let b = Int.random(in:range)
        let c = a + b

        quiz.append(a)
        quiz.append(b)
        quiz.append(c)
        
    }
    
    return quiz.shuffled()
}



