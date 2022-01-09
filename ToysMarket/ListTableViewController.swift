//
//  ListTableViewController.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 08/01/22.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {
    
    let collection = "toyMarket"
    var toyList: [ToyItem] = []
    
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToyItems()
    }

    func loadToyItems() {
        listener = firestore.collection(collection).order(by: "created_at", descending: true).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            
            if let error = error {
                print(error)
                print("Erro ao buscar dados do Firestore")
            } else {
                guard let snapshot = snapshot else {return}
                print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showItemsFrom(snapshot)
                }
            }
        })
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot) {
        toyList.removeAll()
        
        for document in snapshot.documents {

            let data = document.data()
            
            if let name = data["name"] as? String,
                let condition = data["condition"] as? String,
                let donor = data["donor"] as? String,
                let address = data["address"] as? String,
                let phone = data["phone"] as? String,
                let photo = data["photo"],
                let created_at = data["created_at"] as? Timestamp {
                
                let date: Date = created_at.dateValue()
                
                let toyItem = ToyItem(id: document.documentID, name: name, condition: condition, donor: donor, address: address, phone: phone, photo: photo as? String, created_at: date )
                
                print("Toy data: ", toyItem)
                
                toyList.append(toyItem)
            }
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyViewController = segue.destination as? ToyViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            toyViewController.toyItem = toyList[indexPath.row]
            toyViewController.firestore = self.firestore
            toyViewController.collection = self.collection
        } else if let toyFormViewController = segue.destination as? ToyFormViewController {
            toyFormViewController.firestore = self.firestore
            toyFormViewController.collection = self.collection
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ToyItemTableViewCell else {
            print("Failed to load CustomTableViewCell")
            return UITableViewCell()
        }
        
        let toyItem = toyList[indexPath.row]
        cell.configureWith(toyItem)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toyItem = toyList[indexPath.row]
            firestore.collection(collection).document(toyItem.id!).delete()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
