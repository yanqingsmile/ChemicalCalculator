//
//  Group+CoreDataProperties.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 4/6/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group");
    }

    @NSManaged public var title: String?
    @NSManaged public var modifiedDate: NSDate?
    @NSManaged public var ingredients: NSOrderedSet?

}

// MARK: Generated accessors for ingredients
extension Group {

    @objc(insertObject:inIngredientsAtIndex:)
    @NSManaged public func insertIntoIngredients(_ value: Solution, at idx: Int)

    @objc(removeObjectFromIngredientsAtIndex:)
    @NSManaged public func removeFromIngredients(at idx: Int)

    @objc(insertIngredients:atIndexes:)
    @NSManaged public func insertIntoIngredients(_ values: [Solution], at indexes: NSIndexSet)

    @objc(removeIngredientsAtIndexes:)
    @NSManaged public func removeFromIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientsAtIndex:withObject:)
    @NSManaged public func replaceIngredients(at idx: Int, with value: Solution)

    @objc(replaceIngredientsAtIndexes:withIngredients:)
    @NSManaged public func replaceIngredients(at indexes: NSIndexSet, with values: [Solution])

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Solution)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Solution)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSOrderedSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSOrderedSet)

}
