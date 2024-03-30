//
//  IngredientAddCell.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/20/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

class IngredientAddCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    var ingredientArray:[String] = []
    var delegate: AddOrUpdateRecipeVC?
    
    private var cellIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
        amountTextField.delegate = self
        unitTextField.delegate = self
        setupViews()
    }
    
    fileprivate func setupViews() {
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 20.0
    }
    
    func setData(delegate: AddOrUpdateRecipeVC) {
        self.delegate = delegate
        self.nameTextField.text = ""
        self.amountTextField.text = ""
        self.unitTextField.text = ""
    }
    
    func setIndexPath(indexPath: IndexPath) {
        self.cellIndexPath = indexPath
        self.loadData()
    }
    
    func loadData() {
        if let indexPath = self.cellIndexPath {
            let ingredient = self.delegate?.getIngredient(indexPath)
            switch ingredient?.count {
            case 1:
                self.nameTextField.text = ingredient?[0] ?? ""
                self.amountTextField.text = ""
                self.unitTextField.text = ""
            case 2:
                self.nameTextField.text = ingredient?[0] ?? ""
                self.amountTextField.text = ingredient?[1] ?? ""
                self.unitTextField.text = ""
            case 3:
                self.nameTextField.text = ingredient?[0] ?? ""
                self.amountTextField.text = ingredient?[1] ?? ""
                self.unitTextField.text = ingredient?[2] ?? ""
            default:
                break
            }
        }
    }
    
}
extension  IngredientAddCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            //Name of ingredient
            if let indexPath = self.cellIndexPath {
                delegate?.setIngredient(indexPath, nameFromCell: textField.text ?? "", amountFromCell: "", unitFromCell: "", position: 0)
            }
        case 1:
            //Amount of ingredient
            if let indexPath = self.cellIndexPath {
                delegate?.setIngredient(indexPath, nameFromCell: "", amountFromCell: textField.text ?? "", unitFromCell: "", position: 1)
            }
        case 2:
            //Unit of ingredient
            if let indexPath = self.cellIndexPath {
                delegate?.setIngredient(indexPath, nameFromCell: "", amountFromCell: "", unitFromCell: textField.text ?? "", position: 2)
            }
        default:
            break
        }
    }
}

