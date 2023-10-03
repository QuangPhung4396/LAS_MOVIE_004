import UIKit

class DatePickerSheetVC: UIViewController {
    var context: UIViewController!

    @IBOutlet weak var vCancel: PView!
    @IBOutlet weak var vSave: PView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dateSelect = Date()
    var itemSelectCallback: ((Date) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        vCancel.layer.cornerRadius = 24;
        vCancel.layer.masksToBounds = true;
        vSave.layer.cornerRadius = 24;
        vSave.layer.masksToBounds = true;
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } 
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "en_GB")
    }

    @IBAction func actionDismiss(_ sender: Any) {
        self.removeOverlay(contextVC: context)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    @IBAction func actionSave(_ sender: Any) {
        self.removeOverlay(contextVC: context)
        self.dismiss(animated: true) {
            self.save()
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
    }
    
    func save() {
        if(itemSelectCallback != nil) {
            self.itemSelectCallback(datePicker.date)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
