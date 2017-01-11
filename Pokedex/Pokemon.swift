//
//  Pokemon.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/10/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import Foundation

// This is the blueprint for the pokemon, what they need as descriptors, etc.
class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexID: Int!
    
// These are our getters, similar to API proj exercise but those held a buffer if nothing was called and wanted it in a ""...
    var name: String {
        
        return _name
    }
    var pokedexID: Int {
        
        return _pokedexID
    }
    
    init (name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        
    }
}
