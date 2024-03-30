//
//  RecipeDetailVC.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/16/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController,UpdateRecipesDelegate {
    enum TableSection: Int {
        case minEggsRequiredPerServing = 0, ingredientsPerEgg,steps,notes
    }
    let updateSegueID = "ShowUpdateRecipeVC"
    let SectionHeaderHeight: CGFloat = 25
    var totalCellsForIngredient:Int?
    var totalCellsForSteps:Int?
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var eggsNumLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var detailTableView: UITableView!{
        didSet {
            detailTableView.delegate = self
            detailTableView.dataSource = self
            detailTableView.layer.cornerRadius = 20.0
        }
    }
    var recipe:Recipe! {
        didSet {
            totalCellsForIngredient = recipe.ingredientsPerEgg.count
            totalCellsForSteps = recipe.steps.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupFoodImage()
        recipeName.text = recipe.name
    }
    
    fileprivate func setupView() {
        view.layer.cornerRadius = 20.0
        view.backgroundColor = UIColor.darkGray
        view.alpha = 0.8
    }
    
    fileprivate func setupFoodImage() {
        recipeImageView.layer.cornerRadius = 40
        recipeImageView.clipsToBounds = true
        let imageUrl:String? = recipe.image
        if let tempUrl = imageUrl, let url = URL(string: tempUrl) {
            recipeImageView.af_setImage(
                withURL: url,
                placeholderImage: UIImage(named:"TempFoodPic"))
        }else{
            recipeImageView.image = UIImage(named:"TempFoodPic")
        }
    }
    
    @IBAction func addEggsAction(_ sender: Any) {
        let newEggVal = Double(eggsNumLabel.text!)! + 1
        eggsNumLabel.text = String(newEggVal)
        detailTableView.reloadSections([1], with: .none)
    }
    
    @IBAction func removeEggsAction(_ sender: Any) {
        
        if Double(eggsNumLabel.text!)!>=1{
            let newEggVal = Double(eggsNumLabel.text!)! - 1
            eggsNumLabel.text = String(newEggVal)
            
            detailTableView.reloadSections([1], with: .none)
        }
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        performSegue(withIdentifier:updateSegueID, sender: self)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    
    func updateInfoInRecipeDetailVC(withRecipe recipe: Recipe) {
        self.recipe = recipe
        recipeName.text = recipe.name
        detailTableView.reloadData()
    }
    
    func updateTableInHomeSearchVC() {
        // Optional Delegate Method
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateSegueID{
            let updateRecipeVC = segue.destination as! AddOrUpdateRecipeVC
            updateRecipeVC.viewcontollerMode = .update
            updateRecipeVC.setRecipe(recipeToUpdate: recipe)
            updateRecipeVC.delegate = self
        }
    }
}

extension RecipeDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .minEggsRequiredPerServing:
                return 1
            case .ingredientsPerEgg:
                return totalCellsForIngredient ?? 0
            case .steps:
                return totalCellsForSteps ?? 0
            case .notes:
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tableSection = TableSection(rawValue: indexPath.section) {
            switch tableSection {
            case .minEggsRequiredPerServing:
                return 30.0
            case .ingredientsPerEgg:
                return 40.0
            case .steps:
                return 130.0
            case .notes:
                return 500
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: SectionHeaderHeight)
        )
        view.backgroundColor = #colorLiteral(red: 0.4143566489, green: 0.7850795388, blue: 0.7890834808, alpha: 1)
        let label = UILabel(frame: CGRect(
            x: 15,
            y: 0.32*SectionHeaderHeight,
            width: tableView.bounds.width - 30,
            height: 0.9*SectionHeaderHeight)
        )
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .minEggsRequiredPerServing:
                label.text = "Minimum eggs required for 1 serving"
            case .ingredientsPerEgg:
                label.text = "Ingredients per Egg"
            case .steps:
                label.text = "Steps:"
            case .notes:
                label.text = "Note"
            default:
                break
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        
        if let tableSection = TableSection(rawValue: indexPath.section) {
            switch tableSection {
            case .minEggsRequiredPerServing:
                cell.stringForCell = String(recipe.minEggsRequiredPerServing)
            case .ingredientsPerEgg:
                var string = ""
                let newEggVal = Double(eggsNumLabel.text!)!
                for (index, ingredient) in recipe.ingredientsPerEgg[indexPath.row].enumerated() {
                    string += index == 1 ? String((Double(ingredient) ?? 0) * newEggVal) : ingredient
                    string += " "
                }
                cell.stringForCell = string
            case .steps:
                cell.stringForCell = "Step \(indexPath.row+1): \(recipe.steps[indexPath.row])"
            case .notes:
                cell.stringForCell = recipe.notes.count > 0 ? recipe.notes[0] : ""
                
            default:
                break
            }
        }
        return cell
    }
}

