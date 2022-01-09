//
//  ToyCondition.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 08/01/22.
//

import Foundation

enum ToyCondition {
    case Novo
    case Usado
    case Reparos
    
    func getCondition(_ condition: String!) -> Int {
        switch condition {
            case "Novo":
                return 0
            
            
        case .none:
            <#code#>
        case .some(_):
            <#code#>
        }
    }
}
