import UIKit
import FLCharts

class StatisticsVC: UIViewController {
    @IBOutlet weak var pieChart: JPieChart!
    @IBOutlet weak var lblTotalMove: UILabel!
    @IBOutlet weak var vFeeling1: UIView!
    @IBOutlet weak var vFeeling2: UIView!
    @IBOutlet weak var vFeeling3: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFeeling1: UILabel!
    @IBOutlet weak var lblTotalFeeling1: UILabel!
    @IBOutlet weak var lblFeeling2: UILabel!
    @IBOutlet weak var lblTotalFeeling2: UILabel!
    @IBOutlet weak var lblFeeling3: UILabel!
    @IBOutlet weak var lblTotalFeeling3: UILabel!
    @IBOutlet weak var chartView: FLChart!

    var diarys: [DMoviesDetail] = []
    var listFilter : [DMoviesDetail] = []
    var itemAndCountList: [(item: String, count: Int)] = []
    var itemDateAndCounts: [(item: String, count: Int)] = []
    var dataPieCharts: [JPieChartDataSet] = []
    var singMonthsData: [SinglePlotable] = []
    var scatterChartData: FLChartData!
    override func viewDidLoad() {
        super.viewDidLoad()
        scatterChartData = FLChartData(title: "",
                                           data: singMonthsData,
                                           legendKeys: [Key(key: "", color: FLColor(hex: "547CFB"))],
                                           unitOfMeasure: "")
        chartView.setup(data: scatterChartData, type: .line())
        chartView.cartesianPlane.yAxisPosition = .right
        chartView.tintColor = UIColor.black
        chartView.config.dashedLines.color = UIColor(hex: 0x547CFB)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diarys = DMoviesDetail.readFromFileEditJson()
        listFilter = diarys
        lblTotalMove.text = "\(listFilter.count) Move"
        lblTime.text = "All"
        getListPrecentSort()
        reloadDataLineChart()
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
        dateFormatter.dateFormat = "yyyy"
        datePicker.date = Date() // Đặt ngày mặc định là ngày hiện tại
        
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: ActivityEx.screenWidth(), height: 200))
        uiView.addSubview(datePicker)
        // Add constraints to center the UIDatePicker in the container view
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: uiView.centerYAnchor)
        ])
        alertVC.view.addSubview(uiView)
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            getMonthAndYearFromDate(date: datePicker.date) { year, month in
                self.lblTime.text = "\(month) \(year)"
                var newMonth = -1
                listFilter = diarys.filter({ moveDetail in
                    formatStringToDay(time: moveDetail.timeWatch) { weekDate, day, moveMonth, newYear in
                        newMonth = moveMonth
                    }
                    return newMonth == month && year == moveDetail.year
                })
            }
            lblTotalMove.text = "\(listFilter.count) Move"
            getListPrecentSort()
            reloadDataLineChart()
        }
        let allAction = UIAlertAction(title: "All", style: .default) { [self] _ in
            lblTime.text = "All"
            listFilter = diarys
            lblTotalMove.text = "\(listFilter.count) Move"
            getListPrecentSort()
            reloadDataLineChart()
        }
        alertVC.addAction(okAction)
        alertVC.addAction(allAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    func getDataLineChart() {
        itemDateAndCounts = listFilter.map({ move in
            // lay ra thu
            var newWeekDate = ""
            formatStringToDay(time: move.timeWatch) { weekDate, day, moveMonth, newYear in
                newWeekDate = weekDate
            }
            return newWeekDate
        }).reduce(into: [String: Int]()) { counts, item in
            counts[item, default: 0] += 1
        }.map { (item, count) in (item: item, count: count) }
    }
    func reloadDataLineChart() {
        getDataLineChart()
        // Khởi tạo một mảng [PlotableData]
        var plotableDataArray: [PlotableData] = []
        itemDateAndCounts.forEach { itemDate in
            let single = SinglePlotable(name: itemDate.item, value: CGFloat(itemDate.count))
            plotableDataArray.append(single)
        }
        let sortedDaysOfWeek = plotableDataArray.sorted { (item1, item2) -> Bool in
            let order = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            if let index1 = order.firstIndex(of: item1.name), let index2 = order.firstIndex(of: item2.name) {
                return index1 < index2
            }
            
            return false
        }
        chartView.updateChart(data: sortedDaysOfWeek)
    }

    func getListPrecentSort() {
        dataPieCharts.removeAll()
        itemAndCountList = listFilter.map { move in
            return move.nameIcon
        }.reduce(into: [String: Int]()) { counts, item in
            counts[item, default: 0] += 1
        }.map { (item, count) in (item: item, count: count) }
        var newList : [(item: String, count: Int)] = []
        if(itemAndCountList.count > 3) {
             newList = Array(itemAndCountList.prefix(3))
        }else {
            newList = itemAndCountList
        }
        if(newList.count == 1) {
            readData(itemCount: itemAndCountList[0], lblFeeling: lblFeeling1, lblTotal: lblTotalFeeling1)
            vFeeling1.isHidden = false
            vFeeling2.isHidden = true
            vFeeling3.isHidden = true
        }else if(newList.count == 2) {
            readData(itemCount: itemAndCountList[0], lblFeeling: lblFeeling1, lblTotal: lblTotalFeeling1)
            readData(itemCount: itemAndCountList[1], lblFeeling: lblFeeling2, lblTotal: lblTotalFeeling2)
            vFeeling1.isHidden = false
            vFeeling2.isHidden = false
            vFeeling3.isHidden = true
        }else if(newList.count == 3) {
            readData(itemCount: itemAndCountList[0], lblFeeling: lblFeeling1, lblTotal: lblTotalFeeling1)
            readData(itemCount: itemAndCountList[1], lblFeeling: lblFeeling2, lblTotal: lblTotalFeeling2)
            readData(itemCount: itemAndCountList[2], lblFeeling: lblFeeling3, lblTotal: lblTotalFeeling3)
            vFeeling1.isHidden = false
            vFeeling2.isHidden = false
            vFeeling3.isHidden = false
        }else {
            vFeeling1.isHidden = true
            vFeeling2.isHidden = true
            vFeeling3.isHidden = true
            let pieChart = JPieChartDataSet(percent: CGFloat(100), colors: [UIColor(hex: 0xF0F3F6),UIColor(hex: 0xF0F3F6)])
            dataPieCharts.append(pieChart)
        }
        if(dataPieCharts.count > 0) {
            pieChart.lineWidth = 0.2
            pieChart.addChartData(data:dataPieCharts)
        }
       
    }
    func readData(itemCount: (item: String, count: Int), lblFeeling: UILabel, lblTotal: UILabel) {
        let precent = Float(itemCount.count) / Float(listFilter.count) * 100
        print("trungnc precent: \(precent) a\(listFilter.count)")
        let roundedPercentage = String(format: "%.2f", precent) + "%"
        lblFeeling.text = "\(itemCount.item) - \(roundedPercentage)"
        lblTotal.text = "\(itemCount.count) Move"
        
        var newColor: UIColor!
        if(lblFeeling == lblFeeling1) {
            newColor = UIColor(hex: 0x673EFF)
        }else if(lblFeeling == lblFeeling2) {
            newColor = UIColor(hex: 0x3EA2FF)
        }else if(lblFeeling == lblFeeling3) {
            newColor = UIColor(hex: 0xFF9931)
        }
        let pieChart = JPieChartDataSet(percent: CGFloat(precent), colors: [newColor,newColor])
        dataPieCharts.append(pieChart)
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        showDatePickerAlert()
    }
}

