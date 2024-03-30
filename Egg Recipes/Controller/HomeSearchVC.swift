//  ViewController.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/14/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

class HomeSearchVC: UIViewController , UpdateRecipesDelegate {
    let searchCellID = "SearchCell"
    let detailSegueID = "ShowRecipeDetailVC"
    let addRecipeSegueID = "ShowAddRecipeVC"
    var recipeToPass = RecipeObj()
    var tempSearchArray: [RecipeObj] = DataBaseManager.sharedInstance.recipesArray
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchTableview: UITableView!{
        didSet{
            let nibSearchCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
            searchTableview.register(nibSearchCell, forCellReuseIdentifier: searchCellID)
            searchTableview.delegate = self
            searchTableview.dataSource = self
            searchTableview.backgroundView?.alpha = 0.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadSearchTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        customizeSearchBarAppearance()
    }
    
    fileprivate func reloadSearchTableView() {
        UIView.transition(with: self.searchTableview,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {self.searchTableview.reloadData() })
    }
    
    fileprivate func customizeSearchBarAppearance() {
        searchbar.searchBarStyle = .minimal
        searchbar.barStyle = .black
        searchbar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchbar.barTintColor = #colorLiteral(red: 0.4204149544, green: 0.7850520015, blue: 0.78476125, alpha: 1)
        searchbar.isTranslucent = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func updateTableInHomeSearchVC() {
        tempSearchArray = DataBaseManager.sharedInstance.recipesArray
        reloadSearchTableView()
    }
    
    func updateInfoInRecipeDetailVC(withRecipe recipe: Recipe) {
        //optional to implement
    }
    
    func deleteRecipeInRow(row: Int){
        DataBaseManager.sharedInstance.deleteRecipeFromDatabase(recipeID: tempSearchArray[row].id)
        tempSearchArray.remove(at: row)
        reloadSearchTableView()
    }

    @IBAction func addBtnAction(_ sender: Any) {
        performSegue(withIdentifier: addRecipeSegueID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueID{
            let detailVC = segue.destination as! RecipeDetailVC
            detailVC.recipe = recipeToPass.recipeStruct
            detailVC.recipe.uuid = recipeToPass.id
        }else if segue.identifier == addRecipeSegueID{
            let addRecipeVC = segue.destination as! AddOrUpdateRecipeVC
            addRecipeVC.viewcontollerMode = .add
            addRecipeVC.setRecipe(recipeToUpdate: nil)
            addRecipeVC.delegate = self
        }
    }
}

extension HomeSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSearchArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableview.dequeueReusableCell(withIdentifier: searchCellID,
                                                 for: indexPath) as! SearchTableViewCell
        cell.recipe = tempSearchArray[indexPath.row]
        cell.tag = indexPath.row
        cell.setDelegate(delegate:self)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeToPass = tempSearchArray[indexPath.row]
        performSegue(withIdentifier:detailSegueID, sender: self)
    }
}

extension HomeSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            tempSearchArray = DataBaseManager.sharedInstance.recipesArray.filter({($0.recipeStruct?.name.contains(searchText))!})
        }else{
            tempSearchArray = DataBaseManager.sharedInstance.recipesArray
        }
        searchTableview.reloadData()
    }
}

