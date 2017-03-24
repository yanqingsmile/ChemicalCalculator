//
//  Compound+CoreDataClass.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/17/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import CoreData

@objc(Compound)
public class Compound: NSManagedObject {
    class func compoundWithCompoundInfo (compoundInfo:Dictionary<String, Any>, inManagedObjectContext context: NSManagedObjectContext) -> Compound? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Compound")
        request.predicate = NSPredicate(format: "name = %@", compoundInfo["Compound name"] as! CVarArg)
        if let compound = (try? context.fetch(request))?.first as? Compound {
            return compound
        } else if let compound = NSEntityDescription.insertNewObject(forEntityName: "Compound", into: context) as? Compound {
            compound.name = compoundInfo["Compound name"] as? String
            compound.formula = compoundInfo["Molecular formula"] as? String
            compound.molecularMass = Double(compoundInfo["Molar mass"] as! String) ?? 0.0
            compound.purity = 1
            return compound
        }
        return nil
    }
    
    var uppercaseFirstLetterOfName: String {
        get {
            self.willAccessValue(forKey: "uppercaseFirstLetterOfName")
            if let name = self.value(forKey: "name") as? String {
                let firstLetterOfName = String(describing: name[name.startIndex]).uppercased()
                self.didAccessValue(forKey: "uppercaseFirstLetterOfName")
                return firstLetterOfName
            }
            return "NA"
        }
    }
}
