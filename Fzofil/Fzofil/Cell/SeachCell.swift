import UIKit

class SeachCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var vLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
