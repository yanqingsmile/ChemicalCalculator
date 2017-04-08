//
//  Compound+CoreDataProperties.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 4/6/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import CoreData


extension Compound {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Compound> {
        return NSFetchRequest<Compound>(entityName: "Compound");
    }

    @NSManaged public var formula: String?
    @NSManaged public var molecularMass: Double
    @NSManaged public var name: String?
    @NSManaged public var purity: Double
    @NSManaged public var solutions: NSSet?

}

// MARK: Generated accessors for solutions
extension Compound {

    @objc(addSolutionsObject:)
    @NSManaged public func addToSolutions(_ value: Solution)

    @objc(removeSolutionsObject:)
    @NSManaged public func removeFromSolutions(_ value: Solution)

    @objc(addSolutions:)
    @NSManaged public func addToSolutions(_ values: NSSet)

    @objc(removeSolutions:)
    @NSManaged public func removeFromSolutions(_ values: NSSet)

}
