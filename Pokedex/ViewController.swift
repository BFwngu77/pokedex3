//
//  ViewController.swift
//  Pokedex
//
//  Created by Brett Foreman on 1/10/17.
//  Copyright © 2017 Brett Foreman. All rights reserved.
//

import UIKit
import AVFoundation // did this when we created the music button

//delegate: shows this class is delegate for collection view
// data source: says this will hold daya dor collection view
// flow layout: protocol used to modify and set the settings for the layout for the collection view.
// Each UI thing has it's own
// Need a method that will check for each time a keystroke is made, that's what UISearchBarDel is for.

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

// b/c it's tied to the storyboard
    @IBOutlet weak var collection: UICollectionView!
// need to connect the search bar
    @IBOutlet weak var searchBar: UISearchBar!

    
    var pokemon = [Pokemon]() // created and initialized an array of type pokemon...
    
    var filteredPokemon = [Pokemon]() // created and initialized as an empty array of type Pokemon...
    
    var inSearchMode = false // need this boolean for in search mode in order to help the search bar function work
    
    var musicPlayer: AVAudioPlayer! // need a music player variable
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
// assign the delegate and datasource to self, however,unless we create an array of pokemon, which we did above, there was no data going in..
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done // also when you press done key it will remove the keyboard...
    
        parsePokemonCSV()
        initaudio() // turn on music upon view load...
    }
    
    // above we created the music player variable, but now we will initialize it here..
    func initaudio(){
        // need to create a path to the music... the
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        // since this can throw an error we will add a do and catch statement...
        
        do {                                // referring to the path var above
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay() // get it ready for playing
            musicPlayer.numberOfLoops = -1 //loops continuously
            musicPlayer.play() // play it..
            
        } catch let err as NSError {
            print(err.debugDescription)
    }
            
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
            let poke: Pokemon!
            // next will show two options for the cell view depending on if anything was in the search bar, etc.
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
                
            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            
                // This grabs the correct cell inputs from pokecell and combines it with the cell information passed in on the main VC..
                // will assign name and thumb image to pokecell
            }
            
            return cell // if we can grab one of those dequeued then do it" otherwise return an empty generic cell...
            
        } else {
            return UICollectionViewCell()
        }
    } // this bracket ends the dequeue and setting up of cells
    
// When item in collection view is selected, func
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // since we made a segue we wanted to connect two view controllers (not by connecting a cell to the desired vc)... here will be what happens when someone presses cell... we will "take the segue" to the next view.
        var poke: Pokemon! // we're creating a variable called poke, of Pokemon class... if we're in search mode then we can take it from filtered pokemon list, otherwise we can take it from the regular list.
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
                                                    // since "poke" it can be from either list
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
                                // perform segue to PokemonDetailsVC and send in "poke"... 
}
    
// States the number of items in the collection, in our case the png .count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
            
        }
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
    
    // created this for the aciton of pressing the music button
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        // bc the music is playing we will need to find a way for it to stop when we press it...
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            // when playing, it's fully opaque
            sender.alpha = 0.2
       
        } else {
            musicPlayer.play()
            // when paused, it's fully
            sender.alpha = 1.0
        }
    }
    
    // anytime we make a change in the searchBar, whatever is in here is going to be called...
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        // also want to remove the keyboard when search bar is clicked, not only when out of search mode...
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // we want it to show full list when not searching... default
        // when we search, we want the array to change... so we need to create a new array (filter)
        // Below explains what it means to be insearchmode by displaying default settings vs non-default, etc... 
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData() // we're saying, if the search bar is empty, we will revert back to original list of filtered pokemon.
            view.endEditing(true) // will remove keyboard at this point
        } else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
          
    // Saying that the filtered pokemon list is equal to the original list but it's filtered.. and we filter it as $0 (placeholder of any or all obj in original array) taking the name for that, and saying is what we put in the search bar contained inside of that name, and if it is we are going to put it into the filtered pokemon list.
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData() // that will repopulate the collection view with the new data. 
    }
            
}
    // get the function that will get this segue ready to occur...
    // happens before segue occurs and this is where we can set data up to be passed between vc's
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" { // in above segue
        if let detailsVC = segue.destination as? PokemonDetailVC { // new var in pokemondetailsVC
                if let poke = sender as? Pokemon { // poke is sender of class Pokemon
                    detailsVC.pokemon = poke // use detailsVC which we defined as destinationVC
                                            // the destinationVC that contains "pokemon", we're setting it to this VC's ("poke") variable poke. 
                    
                }
            }
        }
    }
}
    
    



