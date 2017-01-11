//
//  PokeCell.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/10/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import UIKit
    // this is the cell on the collection view
    // Don't forget to connect this to the Class title on the collection view cell... we want those values being inherited from there. 
class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
// for each pokecell we will want to create a class of pokemon...
    
    var pokemon: Pokemon!
// Since we want rounded corners on the pokemon collection view cells...
// Rounded corners is implemented at the layer level...
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }

    
    
//func that will call when we are ready to update the contents of each collection view cell!
    func configureCell(_ pokemon:Pokemon) {
        self.pokemon = pokemon
// update cell label
    nameLbl.text = self.pokemon.name.capitalized // Name is in the class folder
    thumbImg.image = UIImage(named: "\(self.pokemon.pokedexID)")
// Integers represent the png for the image in the class folder
// to get the collection view to show the pokemon, we will go to the ViewController to show that. 
        
    }
    
}
