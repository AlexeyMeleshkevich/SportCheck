//
//  StringExtension.swift
//  SportCheck
//
//  Created by Alexey Meleshkevich on 21.09.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation

extension Array {
    func castToIntElements() -> [Int] {
        
        var tempArr: [Int] = []
        
        for element in self {
            guard let stringElement = element as? String else { continue }
            guard let intElement = Int(stringElement) else { continue }
            
            tempArr.append(intElement)
        }
        
        return tempArr
    }
}
