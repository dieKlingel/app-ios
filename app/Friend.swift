//
//  Freind.swift
//  app
//
//  Created by Kai Mayer on 01.02.24.
//

import SwiftData

@Model
class Friend: Identifiable {
    var name: String
    @Attribute(.unique) var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}
