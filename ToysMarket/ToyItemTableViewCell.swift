//
//  ToyItemTableViewCell.swift
//  ToysMarket
//
//  Created by Gian Carlo Mantuan on 08/01/22.
//

import UIKit

class ToyItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewToy: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCondition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWith(_ toyItem: ToyItem) {
        print(toyItem.photo)
        if let toyPhoto = toyItem.photo {
            guard let url = URL(string: toyPhoto) else { return }

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async { [self] in
                    self.imageViewToy.image = UIImage(data: data!)
                }
            }
        }
        
        
        labelName.text = toyItem.name
        labelCondition.text = toyItem.condition
    }

}
