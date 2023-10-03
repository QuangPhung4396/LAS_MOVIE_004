import UIKit

class SearchMoveVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate{

    @IBOutlet weak var tbvSeach: UITableView!
    @IBOutlet weak var tfSeach: UITextField!
    
    var moves: [DMoviesDetail] = []
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfSeach.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.callApi(txtSeach: "")
        
        tbvSeach.delegate = self
        tbvSeach.dataSource = self
        tbvSeach.register(UINib(nibName: "SeachCell", bundle: nil), forCellReuseIdentifier: "SeachCell")
        callApi(txtSeach: "new")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let txtSeach = textField.text!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.callApi(txtSeach: txtSeach)
        }
    }

    func callApi(txtSeach: String) {
        DApiManage().getSeachMove(showLoading: true, txtSeach: txtSeach, page: 1) { data in
            self.moves = data.data as! [DMoviesDetail]
            self.tbvSeach.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SeachCell = tableView.dequeueReusableCell(withIdentifier: "SeachCell", for: indexPath)
        as! SeachCell
        let model = moves[indexPath.row]
        cell.ivPoster.setImage(imageUrl: model.poster_path)
        cell.lblName.text = model.title
        cell.vLine.isHidden = (moves.count - 1) == indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moveItem = moves[indexPath.row]
        let vc = ChooseMoveVC()
        vc.moveDetail = moveItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
