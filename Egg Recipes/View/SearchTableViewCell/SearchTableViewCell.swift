//
//  RecipeTableViewCell.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/16/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var minEggsRequiredLabel: UILabel!
    @IBOutlet weak var voteUpLabel: UILabel!
    @IBOutlet weak var voteDownLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    var delegate: HomeSearchVC?

    var recipe: RecipeObj! {
        didSet {
            recipeName.text = recipe.recipeStruct?.name
            minEggsRequiredLabel.text =  String ((recipe.recipeStruct?.minEggsRequiredPerServing)!)
            voteUpLabel.text = String((recipe.recipeStruct?.upvotes)!)
            voteDownLabel.text = String((recipe.recipeStruct?.downvotes)!)
            
            // Setting the image
            let imageUrl: String? = recipe.recipeStruct?.image
            if let tempUrl = imageUrl, !tempUrl.isEmpty {
                bgImageView.af_setImage(
                    withURL: URL(string: tempUrl)!,
                    placeholderImage: UIImage(named: "TempFoodPic"))
            } else {
                bgImageView.image = UIImage(named: "TempFoodPic")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    fileprivate func setupViews() {
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 40.0
        containerView.clipsToBounds = true
        imageView?.layer.cornerRadius = 40.0
        deleteBtn.layer.cornerRadius = 15.0
    }
    
    @IBAction func voteDownAction(_ sender: Any) {
        if let voteDownStrValue = voteDownLabel.text{
            let voteDownIntVal = Int(voteDownStrValue)!+1
            voteDownLabel.text = String(voteDownIntVal)
            
            // updating DownVote value for RecipeObj in DataBase
            DataBaseManager.sharedInstance.updateVoteDownValue(forRecipeID:recipe.id,
                                                               withValue: voteDownIntVal)
        }else{
            voteDownLabel.text = "0"
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            (sender as! UIButton).transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/4 * 0.999))
        }) { (Bool) in
            UIView.animate(withDuration: 0.2, animations: {
                (sender as! UIButton).transform = .identity
            })
        }
    }
    
    @IBAction func voteUpAction(_ sender: Any) {
        if let voteUpStrValue = voteUpLabel.text {
            let voteUpIntVal = Int(voteUpStrValue)!+1
            voteUpLabel.text = String(voteUpIntVal)
            
            // updating UpVote value for RecipeObj in DataBase
            DataBaseManager.sharedInstance.updateVoteUpValue(
                forRecipeID:recipe.id,
                withValue: voteUpIntVal
            )
        } else {
            voteUpLabel.text = "0"
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            (sender as! UIButton).transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4 * 0.999))
        }) { (Bool) in
            UIView.animate(withDuration: 0.2, animations: {
                (sender as! UIButton).transform = .identity
            })
        }
        
    }
    
    func setDelegate(delegate: HomeSearchVC) {
        self.delegate = delegate
    }
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        delegate?.deleteRecipeInRow(row: tag)
    }
}
