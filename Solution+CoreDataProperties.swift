//
//  Solution+CoreDataProperties.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/17/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import CoreData


extension Solution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Solution> {
        return NSFetchRequest<Solution>(entityName: "Solution");
    }

    @NSManaged public var finalVolume: Double
    @NSManaged public var volumeUnit: String?
    @NSManaged public var finalConcentration: Double
    @NSManaged public var concentrationUnit: String?
    @NSManaged public var chemicalPurity: Double
    @NSManaged public var solute: Compound?

}
