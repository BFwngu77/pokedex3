//
//  ViewController.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/10/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import UIKit
                                        // Add these three things
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//delegate: shows this class is delegate for collection view
// data source: says this will hold daya dor collection view
// flow layout: protocol used to modify and set the settings for the layout for the collection view. 
// Each UI thing has it's own

// b/c it's tied to the storyboard
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]() // created and initialized an array of type pokemon...

    override func viewDidLoad() {
        super.viewDidLoad()
// assign the delegate and datasource to self, however,unless we create an array of pokemon, which we did above, there was no data going in..
        collection.dataSource = self
        collection.delegate = self
        
        parsePokemonCSV()
    }
// Next we must create a function that will parse the data from the csv and put it into a form that is used to us
    func parsePokemonCSV(){
//first we need a path to the csv file.
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! // fine to force unwrap because we know this file is here for sure...
// try and parse it
        do{
            let csv = try CSV(contentsOfURL: path)// b/c csv is dragged in and described as csv, and b/c we call the variable path, this is recoginzable by the program...
            let rows = csv.rows // actual csv rows
            print(rows)
// begin creation of Loop... These new variables are the data titles from csv
// It's also okay to do force unwrap here b/c theres a buffer(catch) that will return an error msg
            for row in rows { // go through each row and pull our ID and Name
                // In this case, we are only looking for the ID and Identifier
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]! // String is inferred ...
                // create pokemon obj called poke and then append that to our pokemon array above... "the var"
                let poke = Pokemon(name: name, pokedexID: pokeID)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
// create our cells... We did this similer thing for TableView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
// We are doing this so we don't need to load 700 plus cells, rather just the ones that will be displayed at one time. Deque helps with this. When you scroll off those on the screen you dequeue and go to the next bunch.
// A string identifying the cell object to be reused. This parameter must not be nil.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell" , for: indexPath) as? PokeCell {
// Next we want to create dynamic cells that don't just output our prorotype cell multiple times
            // This is the pokemon object... taking the pokemon at indexpath.row and assigning it to poke
            let poke = pokemon[indexPath.row]
            // This grabs the correct cell inputs from pokecell and combines it with the cell information passed in on the main VC..
            cell.configureCell(poke) // will assign name and thumb image to pokecell
            
            return cell // if we can grab one of those dequeued then do it" otherwise return an empty generic cell...
            
        } else {
            return UICollectionViewCell()
        }
    } // this bracket ends the dequeue and setting up of cells
    
// When item in collection view is selected, func
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
// States the number of items in the collection, in our case the png .count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count // as many that are in the array
    }
    
    
// States the number of sections in the collection view...
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
// Grants a fixed layout to the collection view 105 x 105
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
}

