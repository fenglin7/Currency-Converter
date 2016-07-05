//
//  Currency.swift
//  API-Sandbox
//
//  Created by Fenglin on 4/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

struct Currency {
    let name: String
    let rate: Double
    
    init(name: String, rate: Double) {
        let index: String.Index = name.startIndex.advancedBy(3)

        self.name = name.substringFromIndex(index)
        self.rate = rate
        
    }
}