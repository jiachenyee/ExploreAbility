//
//  HintsView.swift
//  ExploreAbility
//
//  Created by Muhammad Tafani Rabbani on 27/04/23.
//

import SwiftUI

struct HintsView: View {
    @Namespace var namespace
    @ObservedObject var viewModel : ViewModel
    @State var messege = "Reveal This Challenge Hint"
    @State var isChallenge = false
    @State var challengeStarted = false
//    @State var challenge : [ChallengeHints] = [.singing,.ball]
    let gradient = Gradient(colors: [
            
            Color.black.opacity(0.1),
            Color.black.opacity(0.2),
            Color.black.opacity(0.3),
            Color.black.opacity(0.4),
            Color.black.opacity(0.5),
            Color.black.opacity(0.6),
            Color.black.opacity(0.7),
            Color.black.opacity(0.8),
            Color.black.opacity(0.9),
            Color.black.opacity(1.0),
//            Color.black,
        ])
    var body: some View {
        ZStack {
            LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                
                .edgesIgnoringSafeArea(.all)
                
                
            VStack {
                HStack(spacing:4){
                    if viewModel.hintsModel.hintCounter > 0{
                        ForEach(1...viewModel.hintsModel.hintCounter,id: \.self){ i in
                            CoinsAnimating()
                        }
                    }
                }
                Text("You have \(viewModel.hintsModel.hintCounter) hint credits")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .bold()
                
                if viewModel.hintsModel.hintCounter < 1 {
                    Button {
                        isChallenge.toggle()
                        viewModel.hintsModel.currentDetentCase = .mediumSmallOnly
                        
                        if challengeStarted{
                            viewModel.hintsModel.hintShow.toggle()
                        }
                        
                    } label: {
                        Text(isChallenge ?  "Cancel the challenge"  :"Get more hint Credits!")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18))
                            .bold()
                    }.padding(.top,10)
                }
                
                if challengeStarted{
                    if viewModel.hintsModel.selectedChallenge == .singing{
                        Spacer()
                        SongView(vm: viewModel)
                        Spacer()
                    }else{
                        BallView(viewModel: viewModel)
                    }
                }else{
                    if isChallenge{
                        VStack{
                            ForEach(viewModel.hintsModel.challenge,id: \.id){ c in
                                VStack{
                                    Text(c.rawValue)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .bold()
                                        
//                                    Text(c.description)
//                                        .foregroundColor(.white)
//
//
                                        .multilineTextAlignment(.center)
                                }.frame(maxWidth: .infinity, maxHeight: 50)
                                    .modifier(FlatGlassView())
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        viewModel.hintsModel.selectedChallenge = c
                                        viewModel.hintsModel.currentDetentCase = .allAvailable
                                        challengeStarted.toggle()
                                        
                                    }
                                
                            }
                            if viewModel.hintsModel.challenge.isEmpty{
                                Spacer()
                                Text("Sorry, you have finnished all the Hints Challenges")
                                    .bold()
                                Spacer()
                            }
                        }
                        
                        .matchedGeometryEffect(id: "hint", in: namespace)
                            
                    }else{
                        hint
                        .padding(.top,10)
                        
                    }
                }
                
                
                
                
                Spacer()
            }.padding(.top,50)
        }.onAppear{
            
            if viewModel.hintsModel.isHintShow[viewModel.gameState] != nil{
                messege = "You already got this hint!"
                viewModel.hintsModel.currentDetentCase = .mediumSmallOnly
            }else{
                viewModel.hintsModel.currentDetentCase = .smallOnly
            }
            
        }
        
    }
    
    func validateHint(){
        if viewModel.hintsModel.isHintShow[viewModel.gameState] == nil{
            viewModel.hintsModel.isHintShow[viewModel.gameState] = 1
            withAnimation {
                viewModel.hintsModel.currentDetentCase = .mediumSmallOnly
                messege = "You already got this hint!"
            }
        }else{
            messege = "You already get this hint!"
        }
    }
    
    var hint : some View{
        VStack{
            FrozenButton(action: {
                withAnimation {
                                    viewModel.hintsModel.hintCounter -= 1
                                }
                
                                validateHint()
            },text: messege)
//
            .disabled(viewModel.hintsModel.hintCounter<1 || viewModel.hintsModel.isHintShow[viewModel.gameState] != nil )
            .opacity(viewModel.hintsModel.hintCounter<1 || viewModel.hintsModel.isHintShow[viewModel.gameState] != nil  ? 0.4 : 1)
            .matchedGeometryEffect(id: "hint", in: namespace)
            
            
            if viewModel.hintsModel.isHintShow[viewModel.gameState] != nil {
            
                Text("\((viewModel.gameState.hints ?? "")!)")
                    .font(.callout)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 50)
//                    .modifier(ConvexGlassView())
                    .padding(.horizontal)
            }
            
        }
    }
}
