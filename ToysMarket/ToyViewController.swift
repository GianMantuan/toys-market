//
//  ToyViewController.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 09/01/22.
//

import UIKit
import Firebase

class ToyViewController: UIViewController {

    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDonor: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var segmentedControlCondition: UISegmentedControl!
    @IBOutlet weak var labelPhone: UILabel!
    
    var toyItem: ToyItem?
    var firestore: Firestore?
    var collection: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyFormViewController = segue.destination as? ToyFormViewController {
            toyFormViewController.toyItem = toyItem
            toyFormViewController.firestore = self.firestore
            toyFormViewController.collection = self.collection
        }
    }
    
    func getCondition(_ condition: String) -> Int {
        switch condition {
        case "Novo":
            return 0
        case "Usado":
            return 1
        case "Reparos":
            return 2
        default:
            return 0
        }
    }
    
    func prepareScreen() {
        if let toyItem = toyItem {
            if let image = toyItem.photo {
                guard let url = URL(string: image) else { return }

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async { [self] in
                        self.imageViewPhoto.image = UIImage(data: data!)
                    }
                }
            }
            
            labelName.text = toyItem.name
            labelDonor.text = toyItem.donor
            labelAddress.text = toyItem.address
            labelPhone.text = toyItem.phone
            segmentedControlCondition.selectedSegmentIndex = getCondition(toyItem.condition)
        }
    }

}
