//
//  MyDiaryCell.swift
//  Move004
//
//  Created by apple on 07/09/2023.
//

import UIKit

class MyDiaryCell: UITableViewCell {

    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblSticker: UILabel!
    @IBOutlet weak var ivSticker: UIImageView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    var moveDetail: DMoviesDetail!
    var itemDeleteBlock: ((DMoviesDetail) -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        tvContent.isEditable = false

        // Initialization code
    }
    func setData(moveModel: DMoviesDetail) {
        self.moveDetail = moveModel
        tvContent.text = moveModel.txtNote
        lblSticker.text = moveModel.nameIcon
        ivSticker.image = UIImage(named: "ic_\(moveModel.nameIcon)")
        ivProfile.setImage(imageUrl: moveModel.poster_path)
        formatStringToDay(time: moveModel.timeWatch) { weekdayName, day, month, year in
            lblDate.text = "\(weekdayName) \(day)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionMore(_ sender: Any) {
        if(self.itemDeleteBlock != nil) {
            self.itemDeleteBlock(moveDetail)
        }
    }
}
