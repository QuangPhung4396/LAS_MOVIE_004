import UIKit
import FittedSheets

class ChooseMoveVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var clvIcon: UICollectionView!
    
    @IBOutlet weak var imageWidthHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    var selectedDate = Date()
    var nameIcons: [String] = ["Wow","Good", "Love", "Sleep", "Scare", "Bad"]
    var itemIconSelect = "Wow"
    let calendar = Calendar.current
    var moveDetail: DMoviesDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivProfile.setImage(imageUrl: moveDetail.poster_path)
        lblName.text = moveDetail.title
        clvIcon.delegate = self
        clvIcon.dataSource = self
        clvIcon.register(UINib(nibName: "StickerCell", bundle: nil), forCellWithReuseIdentifier: "StickerCell")
        if(isPad()) {
            imageWidthHeight.constant = 400
        }
        let year = calendar.component(.year, from:
        Date())
        self.lblTime.text = self.dateFormatTime()
        moveDetail.timeWatch = self.dateFormatTime()
        moveDetail.year = year
        moveDetail.timeWatch = dateFormatTime()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        let item = nameIcons[indexPath.row]
        cell.setData(item: item, itemIconSelect: self.itemIconSelect)
        cell.itemClickBlock = { itemSelect in
            self.itemIconSelect = itemSelect
            self.moveDetail.nameIcon = itemSelect
            self.clvIcon.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/6, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func showDatePickerAlert() {
        let vc = DatePickerSheetVC()
        vc.itemSelectCallback = { [self] newDate in
            let year = calendar.component(.year, from: newDate)
            self.selectedDate = newDate
            self.lblTime.text = self.dateFormatTime()
            moveDetail.timeWatch = self.dateFormatTime()
            moveDetail.year = year
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.context = self
        self.addOverlay()
        self.navigationController?.present(vc, animated: true)

    }
    
    func dateFormatTime()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        dateFormatter.locale = Locale(identifier: "en_GB")
        let formattedDate = dateFormatter.string(from: self.selectedDate)
        return formattedDate
    }
    
    @IBAction func actionTime(_ sender: Any) {
        showDatePickerAlert()
    }
    @IBAction func actionNote(_ sender: Any) {
        let vc = NoteVC()
        vc.noteTapBlock = { moveModel in
            self.moveDetail = moveModel
        }
        vc.moveDetail = moveDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        do {
            print("trungnc year: \(moveDetail.year)")
            if(moveDetail.txtNote == ""){
                DAppMessagesManage.shared.showMessage(messageType: .error, message: "You haven't added a note yet. Please add a note to save")
                return

            }
            var listSongDownload = DMoviesDetail.readFromFileEditJson()
            listSongDownload.append(moveDetail)
            let jsonData = try JSONSerialization.data(withJSONObject: listSongDownload.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: NAME_FILE_EDIT_SAVE)
            }
            DispatchQueue.main.async {
                DAppMessagesManage.shared.showMessage(messageType: .success, message: "Save finish")
            }
        } catch {
            print("\(error)")
        }
    }
}
