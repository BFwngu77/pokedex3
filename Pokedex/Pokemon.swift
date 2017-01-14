//
//  Pokemon.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/10/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import Foundation
import Alamofire


// This is the blueprint for the pokemon, what they need as descriptors, etc.
class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description:String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    

// These are our getters, similar to API proj exercise but those held a buffer if nothing was called and wanted it in a ""...
// set getters for all of our properties here... we want to protect the data and guarentee we will have an actual value, or if there isn't anything in there we will return an empty string... Data Encapsulation...
    
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
            return _nextEvolutionTxt
        }
    

    var name: String {
        
        return _name
    }
    var pokedexID: Int {
        
        return _pokedexID
    }
    
    init (name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        
  // whenever we create the pokemon we also want to create the pokemon url, so this is essentially the JSON on pokeapi.co
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
        // calls the JSON
        
    }
    
// we don't want to call all 718 network calls right off the bat, instead we want only the details to show for a specific pokemon when we press on their picture...lazy loading...
// there has been a closure created in the constants folder that essentially sets action to a block of code after view is loaded... not part of vwdidLo...
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { response in
            // pokemonurl is from above and calls the constants information...all the data we will get back is going to be in "response"
            // Once we get a response we set it into a dictionary(next line)
            if let dict = response.result.value as? Dictionary<String, Any>? {
            
            if let weight = dict?["weight"] as? String {
                self._weight = weight // assigned the above variables to the new dict item...
            }
            if let height = dict?["height"] as? String {
                self._height = height
            }
            if let attack = dict?["attack"] as? Int {
                self._attack = "\(attack)"
            }
            if let defense = dict?["defense"] as? Int {
                self._defense = "\(defense)"
            }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
        // we are looking inside the dictionary for the types array in which we look for the string dictionary array within that and then grab the first one in the array (or type, types)...
                if let types = dict?["types"] as? [Dictionary<String,String>] , types.count > 0  {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
        // if there is a type we will for sure get at least one, but for some they have more than one and we need to capture that too, so here's how to do that. Form a loop...
                    }
        // if there's only one then the type above will be called, if theres more than one itll move through however many dictionaries there are with the attribute "name" and itll add onto the previous types mentioned.
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
        // if only one type, it'll show ""
                        } else {
                    self._type = ""
                }
                
                
                
                
                if let descArr = dict?["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let descURL = "\(URL_BASE)\(url)"
                        // second alamofire call was to jump from one json search to the next url hosted json
                        Alamofire.request(descURL).responseJSON(completionHandler: {(response) in
                            if let descDict = response.result.value as? Dictionary<String, Any> {
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                        self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            completed() // this is the call for the second API call...
                        })
                    }
                } else { // if there's no description at all
                    self._description = ""
                }
                
             
                
                
                if let evolutions = dict?["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0 { // only wanna do it if there is an instance of evolution...
                    if let nextEvo = evolutions[0]["to"] as? String {
                    // exclude some possibilities rn, as we did with some of the csv options...
                        if nextEvo.range(of: "method") == nil { // only wanna proceed if it's not a mega. This is saying mega should be nil...
                            self._nextEvolutionName = nextEvo
                            
                    // getting next evolution id... grabbed the id from the url we can see...
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                    // next thing we need is the level...
                                if let lvlExists = evolutions[0]["level"] {
                                    if let lvl = lvlExists as? Int {
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                    print(self._nextEvolutionName)
                    print(self._nextEvolutionId)
                    print(self._nextEvolutionLevel)
                    
                }
            }
            completed() // works for the first API call, however, we need to make another one!
        }
        
    }
}
