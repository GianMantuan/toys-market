//
//  ToyRepository.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 08/01/22.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

class BaseTaskRepository {
  @Published var toys = [Toy]()
}

protocol ToyRepository: BaseTaskRepository {
  func addToy(_ toy: Toy)
  func removeToy(_ toy: Toy)
}

class FirestoreToyRepository: BaseTaskRepository, ToyRepository, ObservableObject {
    lazy var db: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var collection: String = "toyMarket"
    
    private var listenerRegistration: ListenerRegistration?
    
    override init() {
        super.init()
    }
    
    private func loadData() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        listenerRegistration = db.collection(collection).order(by: "created_at", descending: true).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            
            guard let snapshot = snapshot else {return}
            if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                self.toys = snapshot.documents.compactMap {document -> Toy? in
                    try? document.data(as: Toy.self)
                }
            }
        })
    }
    
    func addToy(_ toy: Toy) {
        if let toyID = toy.id {
            do {
                try db.collection(collection).document(toyID).setData(from: toy)
            } catch {
                fatalError("Unable to update toy: \(error.localizedDescription).")
            }
        } else {
            do {
                let _ = try db.collection(collection).addDocument(from: toy)
            } catch {
                fatalError("Unable to save toy: \(error.localizedDescription).")
            }
        }
    }
    
    func removeToy(_ toy: Toy) {
        if let toyID = toy.id {
          db.collection(collection).document(toyID).delete { (error) in
            if let error = error {
              print("Unable to remove document: \(error.localizedDescription)")
            }
          }
        }
    }
}
