//
//  ToyFormViewController.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 08/01/22.
//

import UIKit
import Firebase

class ToyFormViewController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDonor: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var segmentedControlCondition: UISegmentedControl!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var buttonSaveToy: UIButton!
    
    var toyItem: ToyItem?
    var firestore: Firestore?
    var collection: String?
    
    var toyID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let toyItem = toyItem {
            title = "Edit Toy"
            toyID = toyItem.id ?? nil
            
            textFieldName.text = toyItem.name
            textFieldDonor.text = toyItem.donor
            textFieldAddress.text = toyItem.address
            textFieldPhone.text = toyItem.phone
            segmentedControlCondition.selectedSegmentIndex = getCondition(toyItem.condition)
            
            if let image = toyItem.photo {
                let url = URL(string: image)

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async { [self] in
                        self.imageViewPhoto.image = UIImage(data: data!)
                    }
                }
            }
            
            
            buttonSaveToy.setTitle("Edit Toy", for: .normal)
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


    @IBAction func buttonAddPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Toy Photo", message: "Choose where to select your photo", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: { _ in
            self.selectPhoto(sourceType: .photoLibrary)
        })
        let albumAction = UIAlertAction(title: "Saved Album", style: .default, handler: { _ in
            self.selectPhoto(sourceType: .savedPhotosAlbum)
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.selectPhoto(sourceType: .camera)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(libraryAction)
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPhoto(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func buttonSaveToy(_ sender: UIButton) {
        let created_at = Date()
            
        let data: [String: Any] = [
            "name": textFieldName.text!,
            "donor": textFieldDonor.text!,
            "address": textFieldAddress.text!,
            "phone": textFieldPhone.text!,
            "photo": imageViewPhoto.image?.jpegData(compressionQuality: 0.9) as Any,
            "condition": segmentedControlCondition.titleForSegment(at: segmentedControlCondition.selectedSegmentIndex)!,
            "created_at": created_at
        ]
        print(data)
        if (toyID != nil) {
            self.firestore!.collection(collection!).document(toyID).updateData(data)
        } else {
            self.firestore!.collection(collection!).addDocument(data: data)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension ToyFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewPhoto.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
