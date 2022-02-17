//
//  Puzzle.swift
//  QuizGame
//
//  Created by Giuseppe, De Masi on 15/02/22.
//

import SwiftUI

struct Puzzle: Identifiable {
    var id = UUID().uuidString
    var imageName: String
    var answer: String
    var jumbbledWord: String
    
    //breaking down the letter from jumbbled word to array of identifiable characters
    var letters: [Letter] = []
}

struct Letter: Identifiable {
    var id = UUID().uuidString
    var value: String
}

var puzzles = [

    Puzzle(imageName: "WillSmith", answer: "WillSmith", jumbbledWord: "LTHEMSGILSWI"),
    Puzzle(imageName: "Drake", answer: "Drake", jumbbledWord: "EZKRAOLENTD")
    
]
