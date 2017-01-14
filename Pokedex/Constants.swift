//
//  Constants.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/13/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import Foundation

// constants file hosts things that we want to be globally accessable 

let URL_BASE = "https://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

// closure: we want to have the view controller know when data will be available... 
typealias DownloadComplete = () -> () // block of code that is run at a later time (not viewdidload)
