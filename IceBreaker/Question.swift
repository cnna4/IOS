//
//  Question.swift
//  IceBreakerAPP
//
//  Created by Chidi Nna on 2/4/25.
//

import Foundation

class Question {
    var id: String
    var text: String
    
    init?(id: String, data: [String : Any]){
        guard let text = data["text"] as? String
        else {
            return nil
        }
        self.id = id
        self.text = text
    }
    
}
