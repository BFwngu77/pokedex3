
//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/11/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
        // should have all the data passed from previous view controller. 
        
    }

  

}
