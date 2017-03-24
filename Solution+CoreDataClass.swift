//
//  Solution+CoreDataClass.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/17/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import CoreData

@objc(Solution)
public class Solution: NSManagedObject {
    class func solutionWithSolutionInfo (solutionInfo: SolutionInfo, inManagedObjectContext context: NSManagedObjectContext) -> Solution? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Solution")
        if let solution = (try? context.fetch(request))?.first as? Solution {
            return solution
        } else if let solution = NSEntityDescription.insertNewObject(forEntityName: "Solution", into: context) as? Solution {
            solution.solute = solutionInfo.solute
            solution.finalConcentration = solutionInfo.finalConcentration
            solution.concentrationUnit = solutionInfo.concentrationUnit
            solution.finalVolume = solutionInfo.finalVolume
            solution.volumeUnit = solutionInfo.volumeUnit
            solution.soluteMass = solutionInfo.soluteMass
            solution.massUnit = solutionInfo.massUnit
            return solution
        }
        return nil
    }
}

struct SolutionInfo {
    var finalVolume: Double
    var volumeUnit: String?
    var finalConcentration: Double
    var concentrationUnit: String?
    var soluteMass: Double
    var massUnit: String?
    var solute: Compound?
}
