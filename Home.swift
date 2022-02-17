//
//  Home.swift
//  QuizGame
//
//  Created by Giuseppe, De Masi on 15/02/22.
//

import SwiftUI

struct Home: View {
    
    @State var currentPuzzle: Puzzle = puzzles[0]
    @State var selectedLetter: [Letter] = []
    
    var body: some View {
        
        VStack {
           
            //header
            VStack {
                
                HStack {
                    
                    Button {
                        currentPuzzle = puzzles[0]
                        generatingLetters()
                    } label: {
                        Image(systemName: "arrowtriangle.backward.square.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title3)
                            .padding(10)
                            .background(Color("blue") , in: Circle())
                            .foregroundColor(.white)
                    }
                }
                .overlay(
                    Text("Level 1")
                        .fontWeight(.bold)
                )
                
                Image(currentPuzzle.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .padding(.vertical)
                
                HStack(spacing: 10) {
                    
                    ForEach(0..<currentPuzzle.answer.count, id: \.self) {index in
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("blue").opacity(selectedLetter.count > index ? 1 : 0.2))
                                .frame(height: 40)
                            
                            //displaying letters
                            if selectedLetter.count > index {
                                Text(selectedLetter[index].value)
                                    .font(.caption.bold())
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(.white, in: RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            //custom honey grid
            HoneyGrid(items: currentPuzzle.letters) {item in
                
                //hexagon shape
                ZStack {
                    HexagonShape()
                        .fill(isSelected(letter: item) ? Color("gold") : .white)
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 10, y: 5)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: 8)
                    
                    Text(item.value)
                        .font(.largeTitle.bold())
                        .fontWeight(.black)
                        .foregroundColor(isSelected(letter: item) ? .white : .gray.opacity(0.45))
                }
                .contentShape(HexagonShape())
                .onTapGesture {
                    //adding letters
                    addLetter(letter: item)
                }
            }
            
            //"next" button
            Button {
                selectedLetter.removeAll()
                currentPuzzle = puzzles[1]
                generatingLetters()
            } label: {
                Text("Next")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color("gold"), in: RoundedRectangle(cornerRadius: 15))
            }
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            .disabled(selectedLetter.count != currentPuzzle.answer.count)
            .opacity(selectedLetter.count != currentPuzzle.answer.count ? 0.6 : 1)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BG"))
        .onAppear {
            generatingLetters()
        }
    }
    
    func addLetter(letter: Letter) {
        
        if selectedLetter.count == currentPuzzle.answer.count { return }
        
        withAnimation {
            if isSelected(letter: letter) {
                selectedLetter.removeAll {currentLetter in
                    return currentLetter.id == letter.id
                }
            } else {
                if selectedLetter.count == currentPuzzle.answer.count { return }
                selectedLetter.append(letter)
            }
        }
    }
    
    //checking if there is one laready
    func isSelected(letter: Letter) -> Bool {
        return selectedLetter.contains { currentSelection in
            return currentSelection.id == letter.id
        }
    }
    
    func generatingLetters() {
        currentPuzzle.jumbbledWord.forEach { character in
            currentPuzzle.letters.append(Letter(value: String(character)))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
