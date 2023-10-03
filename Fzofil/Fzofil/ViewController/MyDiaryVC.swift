import UIKit

class MyDiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tbvDiary: UITableView!
    @IBOutlet weak var vEmpty: UIView!
    var diarys: [DMoviesDetail] = []
    var filterSeach: [DMoviesDetail] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvDiary.delegate = self
        tbvDiary.dataSource = self
        tbvDiary.register(UINib(nibName: "MyDiaryCell", bundle: nil), forCellReuseIdentifier: "MyDiaryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diarys = DMoviesDetail.readFromFileEditJson()
        filterSeach = diarys
        self.lblTime.text = "All"
        vEmpty.isHidden = diarys.count != 0
        tbvDiary.isHidden = !vEmpty.isHidden
        tbvDiary.reloadData()
    }
    func removeItem() {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: diarys.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: NAME_FILE_EDIT_SAVE)
            }
            DispatchQueue.main.async {
                DAppMessagesManage.shared.showMessage(messageType: .error, message: "Remove diary finish")
            }
        } catch {
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSeach.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDiaryCell", for: indexPath) as! MyDiaryCell
        let model = filterSeach[indexPath.row]
        cell.setData(moveModel: model)
        cell.itemDeleteBlock = { [self] moveDelete in
            let index = filterSeach.firstIndex { move in
                return moveDelete.title == move.title
            } ?? -1
            if(index > -1) {
                filterSeach.remove(at: index)
                tbvDiary.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
                removeItem()
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = diarys[indexPath.row]
        let vc = NoteVC()
        vc.moveDetail = model
        vc.isFromSave = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showDatePickerAlert() {
        let alertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let datePicker: UIDatePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: ActivityEx.screenWidth(), height: 200))
        uiView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: uiView.centerYAnchor)
        ])
        alertVC.view.addSubview(uiView)
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            getMonthAndYearFromDate(date: datePicker.date) { year, month in
                self.lblTime.text = "\(month) \(year)"
                var newMonth = -1
                filterSeach = diarys.filter({ moveDetail in
                    formatStringToDay(time: moveDetail.timeWatch) { weekDate, day, moveMonth, newYear in
                        newMonth = moveMonth
                    }
                    return newMonth == month && year == moveDetail.year
                })
                vEmpty.isHidden = filterSeach.count != 0
                tbvDiary.isHidden = !vEmpty.isHidden
                tbvDiary.reloadData()
            }
        }
        let allAction = UIAlertAction(title: "All", style: .default) { [self] _ in
            self.lblTime.text = "All"
            filterSeach = diarys
            vEmpty.isHidden = true
            tbvDiary.isHidden = false
            tbvDiary.reloadData()
        }
        alertVC.addAction(okAction)
        alertVC.addAction(allAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func actionSelectDate(_ sender: Any) {
        showDatePickerAlert()
    }
}
