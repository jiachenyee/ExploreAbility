//
//  ContentView.swift
//  SwiftUIWithSprite
//
//  Created by Muhammad Tafani Rabbani on 22/05/23.
//

import SwiftUI
import SpriteKit
// import this
import AVFoundation



struct BallView: View {
    var scene = GameScene()
    @State var counter = 0
    @ObservedObject var viewModel : ViewModel
    @State var isFinished = false
    var body: some View {
        ZStack {
            
            
            if isFinished{
                Spacer()
                VStack{
                    if counter == 3{
                        Text("You got it Right!")
                            .font(.largeTitle)
                            .onAppear{
                                let systemSoundID: SystemSoundID = 1407
                                AudioServicesPlaySystemSound(systemSoundID)
                                viewModel.hintsModel.hintCounter += 1
                                viewModel.hintsModel.challenge =  viewModel.hintsModel.challenge.filter({$0 != .ball})
                                DispatchQueue.main.asyncAfter(deadline: .now()+2){
                                    viewModel.hintsModel.hintShow = false
                                }
                                
                            }
                        
                    }else{
                        Text("Sorry, you guessed it wrong!")
                            .font(.largeTitle)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now()+2){
                                    viewModel.hintsModel.hintShow = false
                                }
                            }
                    }
                    Spacer()
                }
                
                
            }else{
                SpriteView(scene: scene)
//                    .ignoresSafeArea()
                    .opacity(0)
                VStack{
                    Text("Try moving around your phone and predict how many balls are there?")
                        .multilineTextAlignment(.center)
                    
                    Stepper("", value: $counter).labelsHidden()
                        
                    Text("\(counter)")
                        .font(.title)
                        .bold()
                    
                    FrozenButton(action: {
                        isFinished.toggle()
                    }, text: "Submit")
                }
            }
            
            
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
