
//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/11/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    var pokemon: Pokemon!

// creating all the outlets for the VC that has all the details of the selected pokemon on it. 
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexidLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseattackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   // should have all the data passed from previous view controller.
        nameLbl.text = pokemon.name.capitalized
     
        let img = UIImage(named: "\(pokemon.pokedexID)")
            // this sets the UI Image on the view, when it loads, to the correct png (represented by a string)
        mainImg.image = img
        currentEvoImg.image = img
        pokedexidLbl.text = "\(pokemon.pokedexID)"
        
        pokemon.downloadPokemonDetail {
            // whatever we write will only be called after the network call is complete!
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        baseattackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        // need to check for pokemon who may not have evolution id's
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false     // this nextevoId is naming the img png integer being called
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL  \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
    }
    
    
// function for the back button. dismisses the ViewController
    @IBAction func backbuttonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  

}
