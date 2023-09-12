//
//  NoteVC.swift
//  Move004
//
//  Created by Trung Nguyễn on 06/09/2023.
//

import UIKit

class NoteVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imageWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var tvHint: UITextView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var isFromSave = false
    var moveDetail: DMoviesDetail!
    var noteTapBlock: ((DMoviesDetail) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        tvHint.delegate = self
        ivPoster.setImage(imageUrl: moveDetail.poster_path)
        lblName.text = moveDetail.title
        lblTime.text = moveDetail.timeWatch
        ivIcon.image = UIImage(named: "ic_\(moveDetail.nameIcon)")
        tvHint.text = moveDetail.txtNote
        lblHint.isHidden = moveDetail.txtNote != ""
        btnSave.isHidden = isFromSave
        if(isPad()) {
            imageWidthContraint.constant = 300
        }

        // Do any additional setup after loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString = (textView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        lblHint.isHidden = newString.count != 0
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        lblHint.isHidden = true
        return true
    }


    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        moveDetail.txtNote = tvHint.text
        if(self.noteTapBlock != nil) {
            self.noteTapBlock(self.moveDetail)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
