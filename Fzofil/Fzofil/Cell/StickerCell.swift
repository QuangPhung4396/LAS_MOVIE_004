import UIKit

class StickerCell: UICollectionViewCell {
    
    @IBOutlet weak var ivSticker: UIImageView!
    @IBOutlet weak var lblScare: UILabel!
    
    var itemClickBlock: ((String) -> Void)!
    var itemSelect: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(item: String, itemIconSelect: String) {
        self.itemSelect = item
        lblScare.text = item
        let nameIcon = "ic_\(item.lowercased())"
        ivSticker.image = UIImage(named: nameIcon)
        lblScare.textColor = itemIconSelect == item ? UIColor.green : UIColor.black
    }

    @IBAction func actionClick(_ sender: Any) {
        if(self.itemClickBlock != nil) {
            self.itemClickBlock(itemSelect)
        }
    }
}
