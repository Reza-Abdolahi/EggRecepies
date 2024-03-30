//
//  RecipeObj.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/16/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    var name: String
    var minEggsRequiredPerServing: Int
    var ingredientsPerEgg: [[String]]
    var upvotes, downvotes, lastUpdate: Int
    var steps, notes: [String]
    let image: String
    var uuid:String?
}

typealias Recipes = [Recipe]


