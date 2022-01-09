//
//  Toy.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 08/01/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Toy: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var condition: String
    var donor: String
    var address: String
    var phone: String
    var photo: String
    @ServerTimestamp var created_at: Timestamp?
}
