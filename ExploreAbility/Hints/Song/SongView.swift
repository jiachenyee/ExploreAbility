//
//  SongView.swift
//  ExploreAbility
//
//  Created by Muhammad Tafani Rabbani on 28/05/23.
//
import SwiftUI
import AVFoundation

struct SongView: View {
    @ObservedObject var vm : ViewModel
    @StateObject var viewModel = ShazamVM()
    @State var isFound = false {
        didSet{
            if isFound == false{
                viewModel.thePrediction = Track()
            }
        }
    }
    var body: some View {
        VStack {
            
            Text("What is Mario Favorite Songs?")
            //            Button(viewModel.isRecording ? "Stop":"\(Image(systemName: "mic"))"){
            //                viewModel.listenMusic()
            //            }
            
            Button {
                viewModel.listenMusic()
            } label: {
                Image(systemName: viewModel.isRecording ? "mic.fill" : "mic")
                    .resizable()
                    .frame(width: 35,height: 50)
                    .scaledToFill()
            }.padding()
            
            if !viewModel.thePrediction.title.isEmpty && viewModel.thePrediction.title == "Asmalibrasi"{
                Text("You Found it!")
                    .onAppear{
                        let systemSoundID: SystemSoundID = 1407
                        AudioServicesPlaySystemSound(systemSoundID)
                        DispatchQueue.main.asyncAfter(deadline: .now()+2){
                            self.isFound = true
                            self.viewModel.stopRecording()
                        }
                    }
            }
        }
        .sheet(isPresented: $isFound) {
            catalog
            
        }
    }
    
    var catalog : some View{
        ZStack{
            AsyncImage(url: viewModel.thePrediction.artwork){phase in
                if let image = phase.image{
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Color.white
                }
            }.overlay(.ultraThinMaterial)
            
            VStack{
                AsyncImage(url: viewModel.thePrediction.artwork){phase in
                    if let image = phase.image{
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:getRect().width * 0.5,height: 300)
                            .cornerRadius(12)
                    }else{
                        ProgressView()
                    }
                }
                
                Text(viewModel.thePrediction.title)
                    .font(.title.bold())
                Text("Artist: **\(viewModel.thePrediction.artist)**")
                
                
                
                
            }
            
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.vm.hintsModel.hintCounter += 1
                self.vm.hintsModel.challenge =  self.vm.hintsModel.challenge.filter({$0 != .singing})
                //                self.vm.hintsModel.hintShow.toggle()
            }
        }
    }
}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}

//struct SongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongView()
//    }
//}
