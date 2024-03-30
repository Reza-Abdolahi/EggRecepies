//
//  Recipes.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/17/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import Foundation
import RealmSwift
 
class RecipeObj: Object{
    @objc dynamic var structData: Data? = nil
    @objc dynamic var id: String = ""
    
    var recipeStruct: Recipe? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(Recipe.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy() -> RecipeObj {
        return RecipeObj(value: self)
    }
}

