//
//  GameOverUnlockedView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import SwiftUI

struct GameOverUnlockedView: View {
    
    @State private var text = ""
    @State private var headerIsAnimating = false
    @State private var dataReceivedCompletely = false
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var imageState = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            if dataReceivedCompletely {
                Text("RECEIVED INCOMING MESSAGE:")
                    .foregroundColor(.green)
                    .bold()
                    .padding(.bottom)
            } else {
                Text("RECEIVING INCOMING MESSAGE:")
                    .foregroundColor(.red)
                    .bold()
                    .opacity(headerIsAnimating ? 0.5 : 1)
                    .padding(.bottom)
            }
            Text(text)
                .foregroundColor(.white)
            
            Spacer()
            
            Image("radiowave.00\(imageState + 1)")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 30)
            
            Text("\(text.count) BYTES RECEIVED")
                .foregroundColor(.white)
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .fontDesign(.monospaced)
        .onAppear {
            animateTextIn()
            withAnimation(.easeInOut.repeatForever()) {
                headerIsAnimating.toggle()
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                imageState += 1
                imageState %= 3
            }
        }
    }
    
    func animateTextIn() {
        let fullText = """
CONGRATULATIONS!

YOU COMPLETED THE MISSION.

REPORT TO AUDITORIUM TO UPLOAD YOUR DEVICE DATA TO THE SERVER.

UPLOADING YOUR DATA:
PUT YOUR PHONE DOWN AT THE COLLECTION POINT AND STAND BACK. YOUR DATA WILL BE UPLOADED AUTOMATICALLY.

THANK YOU.

---
"""
        let strings = [
            randomCharacters(length: 3),
            randomCharacters(length: 3),
            randomCharacters(length: 3),
            randomCharacters(length: 3),
            randomCharacters(length: 3),
            randomCharacters(length: 3),
            randomCharacters(length: 10),
            randomCharacters(length: 10),
            randomCharacters(length: 10),
            randomCharacters(length: 10),
            randomCharacters(length: 10),
            randomCharacters(length: 10),
            randomCharacters(length: 10),
            randomCharacters(length: 15),
            randomCharacters(length: 15),
            randomCharacters(length: 15),
            randomCharacters(length: 15),
            randomCharacters(length: 15)
        ] + (16...fullText.count).map { count in
            String(fullText.prefix(upTo: fullText.index(fullText.startIndex, offsetBy: count)))
        }
        
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            text = strings[index]
            
            if !text.last!.isWhitespace {
                UIImpactFeedbackGenerator().impactOccurred()
            }
            
            if index < strings.count - 1 {
                index += 1
            } else {
                timer.invalidate()
                withAnimation {
                    dataReceivedCompletely = true
                }
            }
        }
    }
    
    func randomCharacters(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-=<>?/\\|{}[];':\",./`~abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

struct GameOverUnlockedView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverUnlockedView()
    }
}
