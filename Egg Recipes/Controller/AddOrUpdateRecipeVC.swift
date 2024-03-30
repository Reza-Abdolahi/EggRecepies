//
//  AddRecipeVC.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/20/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

protocol UpdateRecipesDelegate: class {
    func updateTableInHomeSearchVC()
    func updateInfoInRecipeDetailVC(withRecipe recipe:Recipe)
}

class AddOrUpdateRecipeVC: UIViewController{
    
    enum ViewControllerMode: Int {
        case add,update
    }
    enum TableSection: Int {
        case name = 0, minEggsRequiredPerServing,ingredientsPerEgg,steps,notes
    }
    
    // MARK: - Cell NIBs
    let nameAddCellNIB = UINib(nibName: "NameAddCell", bundle: Bundle.main)
    let minEggsAddCellNIB = UINib(nibName: "MinEggsAddCell", bundle: Bundle.main)
    let ingredientAddCellNIB = UINib(nibName: "IngredientAddCell", bundle: Bundle.main)
    let stepsAddCellNIB = UINib(nibName: "StepsAddCell", bundle: Bundle.main)
    let noteAddCellNIB = UINib(nibName: "NoteAddCell", bundle: Bundle.main)
    
    // MARK: - Cell IDs
    let nameAddCellID = "NameAddCell"
    let minEggsAddCellID = "MinEggsAddCell"
    let ingredientAddCellID = "IngredientAddCell"
    let stepsAddCellID = "StepsAddCell"
    let noteAddCellID = "NoteAddCell"
    
    // MARK: - Dimentions/Sizes
    let sectionHeaderHeight: CGFloat = 60.0
    let heightForNormalCell: CGFloat = 80.0
    let heightForIngredientCell: CGFloat = 200.0
    var numOfCellsForIngredientsSection: Int = 1
    var numOfCellsForstepsSection: Int = 1
    lazy var addBtnWidth = view.frame.size.width/10
    lazy var addBtnXPos:CGFloat = {
        return view.frame.size.width - ((2*addBtnWidth) + 8.0)
    }()
    lazy var addBtnYPos:CGFloat = {
        return sectionHeaderHeight/2 - (addBtnWidth/2)
    }()
    lazy var heightForIngredientSection:CGFloat = {
        return heightForIngredientCell * CGFloat(numOfCellsForIngredientsSection)
    }()
    lazy var heightForStepsSection:CGFloat = {
        return heightForNormalCell * CGFloat(numOfCellsForstepsSection)
    }()
    
    @IBOutlet weak var addTableView: UITableView!{
        didSet{
            addTableView.delegate = self
            addTableView.dataSource = self
            addTableView.layer.cornerRadius = 40.0
            addTableView.register(nameAddCellNIB,forCellReuseIdentifier: nameAddCellID)
            addTableView.register(minEggsAddCellNIB,forCellReuseIdentifier: minEggsAddCellID)
            addTableView.register(ingredientAddCellNIB,forCellReuseIdentifier:ingredientAddCellID)
            addTableView.register(stepsAddCellNIB,forCellReuseIdentifier: stepsAddCellID)
            addTableView.register(noteAddCellNIB,forCellReuseIdentifier: noteAddCellID)
        }
    }
    
    weak var delegate: UpdateRecipesDelegate?
    var viewcontollerMode: ViewControllerMode = .add
    var recipe = Recipe(
        name: "",
        minEggsRequiredPerServing: 0,
        ingredientsPerEgg: [[]],
        upvotes: 0,
        downvotes: 0,
        lastUpdate: 0,
        steps: [],
        notes: [],
        image: "",
        uuid: ""
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setRecipe(recipeToUpdate: Recipe?){
        if viewcontollerMode == .add {
            recipe = Recipe(name:"",
                            minEggsRequiredPerServing: 0,
                            ingredientsPerEgg: [[]],
                            upvotes: 0,
                            downvotes: 0,
                            lastUpdate: 0,
                            steps: [""],
                            notes: [],
                            image: "",
                            uuid: "")
        } else {
            // Update Mode
            if let recipeToUpdate = recipeToUpdate{
                recipe = recipeToUpdate
            }
        }
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if viewcontollerMode == .add{
            DataBaseManager.sharedInstance.addRecipeToDatabase(recipe:recipe)
        }else{
            // Update mode
            DataBaseManager.sharedInstance.updateRecipe(recipe: recipe , uuid: recipe.uuid ?? "")
            self.delegate?.updateInfoInRecipeDetailVC(withRecipe: recipe)
        }
        self.delegate?.updateTableInHomeSearchVC()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddOrUpdateRecipeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .name:
                return 1
            case .minEggsRequiredPerServing:
                return 1
            case .ingredientsPerEgg:
                return recipe.ingredientsPerEgg.count
            case .steps:
                return recipe.steps.count
            case .notes:
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tableSection = TableSection(rawValue: indexPath.section) {
            switch tableSection {
            case .name:
                return 100.0
            case .minEggsRequiredPerServing:
                return 100.0
            case .ingredientsPerEgg:
                return heightForIngredientSection
            case .steps:
                return heightForStepsSection
            case .notes:
                return 500.0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: tableView.bounds.width,
                                        height: sectionHeaderHeight))
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15,
                                          y: 0,
                                          width: tableView.bounds.width - 30,
                                          height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        
        let addCellBtn = UIButton(type: .custom)
        addCellBtn.setImage(UIImage(named: "add"), for: .normal)
        addCellBtn.frame = CGRect(x:addBtnXPos ,
                                  y:addBtnYPos,
                                  width:addBtnWidth,
                                  height: addBtnWidth)
        addCellBtn.addTarget(self, action: #selector(addCellAction), for: .touchUpInside)
        addCellBtn.tag = section
        
        let deleteCellBtn = UIButton(type: .custom)
        deleteCellBtn.setImage(UIImage(named: "remove"), for: .normal)
        deleteCellBtn.frame = CGRect(x:addBtnXPos - (addBtnWidth + 8),
                                     y: addBtnYPos,
                                     width:addBtnWidth,
                                     height: addBtnWidth)
        deleteCellBtn.addTarget(self, action: #selector(deleteCellAction), for: .touchUpInside)
        deleteCellBtn.tag = section
        
        view.addSubview(label)
        
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .name:
                label.text = "Name:"
            case .minEggsRequiredPerServing:
                label.text = "Minimum eggs required for 1 serving:"
            case .ingredientsPerEgg:
                label.text = "Ingredients per Egg:"
                view.addSubview(addCellBtn)
                view.addSubview(deleteCellBtn)
            case .steps:
                label.text = "Steps:"
                view.addSubview(addCellBtn)
                view.addSubview(deleteCellBtn)
            case .notes:
                label.text = "Note:"
            default:
                label.text = ""
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            // Name
            let cell = tableView.dequeueReusableCell(withIdentifier: nameAddCellID, for: indexPath) as! NameAddCell
            cell.setData(delegate: self)
            cell.loadData()
            return cell
        case 1:
            // MinEggsRequired
            let cell = tableView.dequeueReusableCell(withIdentifier: minEggsAddCellID, for: indexPath) as! MinEggsAddCell
            cell.setData(delegate: self)
            cell.loadData()
            return cell
        case 2:
            // Ingredient
            let cell = tableView.dequeueReusableCell(withIdentifier: ingredientAddCellID, for: indexPath) as! IngredientAddCell
            cell.setData(delegate: self)
            cell.setIndexPath(indexPath: indexPath)
            return cell
        case 3:
            // Steps
            let cell = tableView.dequeueReusableCell(withIdentifier: stepsAddCellID, for: indexPath) as! StepsAddCell
            cell.setData(delegate: self)
            cell.setIndexPath(indexPath: indexPath)
            return cell
        case 4:
            // Note
            let cell = tableView.dequeueReusableCell(withIdentifier: noteAddCellID, for: indexPath) as! NoteAddCell
            cell.setData(delegate: self)
            cell.loadData()
            return cell
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    // MARK: - Set & Get Name
    func setName(nameFromCell: String) {
        self.recipe.name = nameFromCell
    }
    func getName() -> String{
        return self.recipe.name
    }
    
    // MARK: - Set & Get MinEggs
    func setMinEggs(minEggsFromCell: String) {
        self.recipe.minEggsRequiredPerServing = Int(minEggsFromCell) ?? 0
    }
    func getMinEggs() -> String{
        return String(self.recipe.minEggsRequiredPerServing)
    }
    
    // MARK: - Set & Get Ingredient
    func setIngredient(_ indexPath: IndexPath, nameFromCell: String, amountFromCell: String, unitFromCell: String, position: Int) {
        
        switch indexPath.section {
        case 2:
            // ingredient
            if self.recipe.ingredientsPerEgg[indexPath.row].count == 0 {
                self.recipe.ingredientsPerEgg[indexPath.row].append("")
                self.recipe.ingredientsPerEgg[indexPath.row].append("")
                self.recipe.ingredientsPerEgg[indexPath.row].append("")
            } else if self.recipe.ingredientsPerEgg[indexPath.row].count == 1 {
                self.recipe.ingredientsPerEgg[indexPath.row].append("")
                self.recipe.ingredientsPerEgg[indexPath.row].append("")
            } else if self.recipe.ingredientsPerEgg[indexPath.row].count == 2 {
                self.recipe.ingredientsPerEgg[indexPath.row].append("")
            }
            switch position {
            case 0:
                self.recipe.ingredientsPerEgg[indexPath.row][0] = nameFromCell
            case 1:
                self.recipe.ingredientsPerEgg[indexPath.row][1] = amountFromCell
            case 2:
                self.recipe.ingredientsPerEgg[indexPath.row][2] = unitFromCell
            default:
                break
            }
            
        default:
            break
        }
    }
    
    
    func getIngredient(_ indexPath: IndexPath) -> [String] {
        switch indexPath.section {
        case 2:
            // ingredient
            return self.recipe.ingredientsPerEgg[indexPath.row]
        default:
            return []
        }
    }
    
    // MARK: - Set & Get Steps
    func setSteps(_ indexPath: IndexPath, stepFromCell: String) {
        switch indexPath.section {
        case 3:
            // steps
            self.recipe.steps[indexPath.row] = stepFromCell
        default:
            break
        }
    }
    func getSteps(_ indexPath: IndexPath) -> String? {
        switch indexPath.section {
        case 3:
            // steps
            return self.recipe.steps[indexPath.row]
        default:
            return nil
        }
    }
    
    // MARK: - Set & Get Note
    func setNote(noteFromCell: String) {
        if self.recipe.notes.count == 0 {
            self.recipe.notes.append(noteFromCell)
        }else{
            self.recipe.notes[0] = noteFromCell
        }
    }
    func getNote() -> String? {
        return self.recipe.notes.first
    }
    
    @objc func addCellAction(_ button:UIButton){
        switch button.tag{
        case 2:
            // Add Cell for Ingredient
            self.recipe.ingredientsPerEgg.append([])
            addTableView.reloadSections([2], with: .fade)
        case 3:
            // Add Cell for Steps
            self.recipe.steps.append("")
            addTableView.reloadSections([3], with: .fade)
        default:
            break
        }
    }
    
    @objc func deleteCellAction(_ button:UIButton){
        switch button.tag{
        case 2:
            // Remove Cell for Ingredient
            if numOfCellsForIngredientsSection > 0 {
                numOfCellsForIngredientsSection-=1
                self.recipe.ingredientsPerEgg.remove(at: self.recipe.ingredientsPerEgg.count - 1)
                addTableView.reloadSections([2], with: .fade)
            }
            break
        case 3:
            // Remove Cell for Steps
            if numOfCellsForstepsSection > 0 {
                numOfCellsForstepsSection-=1
                self.recipe.steps.remove(at: self.recipe.steps.count - 1)
                addTableView.reloadSections([3], with: .fade)
            }
            break
        default:
            break
        }
    }
}

