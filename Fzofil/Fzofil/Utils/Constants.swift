import Foundation
public let NAME_FILE_EDIT_SAVE = "list_move_save.json"

#if DEBUG
    public let admod_banner = "ca-app-pub-3940256099942544/2934735716"
    public let admod_interstital = "ca-app-pub-3940256099942544/4411468910"
    public let admod_interstital_splash = "ca-app-pub-3940256099942544/4411468910"
    public let admod_reward = ""
    public let admod_reward_interstital = ""
    public let admod_small_native = "ca-app-pub-3940256099942544/3986624511"
    public let admod_medium_native = "ca-app-pub-3940256099942544/3986624511"
    public let admod_manual_native = "ca-app-pub-3940256099942544/3986624511"
    public let admod_app_open = "ca-app-pub-3940256099942544/3419835294"

    public let max_banner = ""
    public let max_interstital = ""
    public let max_splash = ""
    public let max_reward = ""
    public let max_small_native = ""
    public let max_medium_native = ""
    public let max_manual_native = ""
    public let max_app_open = ""
#else
    public let admod_banner = "ca-app-pub-2299291161271404/9078447157"
    public let admod_interstital = "ca-app-pub-2299291161271404/3831109468"
    public let admod_interstital_splash = "ca-app-pub-2299291161271404/4401955100"
    public let admod_reward = "ca-app-pub-2299291161271404/1862302118"
    public let admod_reward_interstital = "ca-app-pub-2299291161271404/9994823444"
    public let admod_small_native = "ca-app-pub-2299291161271404/6265701111"
    public let admod_medium_native = "ca-app-pub-2299291161271404/2892312758"
    public let admod_manual_native = "ca-app-pub-2299291161271404/9715621848"
    public let admod_app_open = "ca-app-pub-2299291161271404/4210383412"

    public let max_banner = "3eb762231add8fd4"
    public let max_interstital = "1f9b403d5a8f0266"
    public let max_splash = "7c52d1e6f4119b34"
    public let max_reward = "f52a6e7ec0d5f595"
    public let max_small_native = "744d9c44cd7974b3"
    public let max_medium_native = "a56577ce4a8ab52f"
    public let max_manual_native = "f87d026a16f42b00"
    public let max_app_open = "ce77fd5e1afa39d0"
#endif

func getMonthAndYearFromDate(date: Date,completion: ((Int, Int) -> Void?)) {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    completion(year, month)
}

public func formatStringToDay(time: String,callback: ((String, Int, Int, Int) -> Void?)) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM, HH:mm"
    dateFormatter.locale = Locale(identifier: "en_GB") // Đặt ngôn ngữ hiển thị thành tiếng Anh - Vương quốc Anh hoặc "en_US" cho tiếng Anh - Hoa Kỳ

    if let date = dateFormatter.date(from: time) { // Thay thế bằng giá trị date của bạn
        let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday, .day, .month, .year], from: date)
            
            if let weekday = components.weekday, let day = components.day, let month = components.month, let year = components.year {
                dateFormatter.dateFormat = "E" // Đặt định dạng cho tên thứ dưới dạng "E" để lấy tên ngắn (Mon, Tue, ...)
                let weekdayName = dateFormatter.string(from: date)
                callback(weekdayName, day, month, year)
            }
    }
}
public func dataToJSON(data: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: [])
    } catch let myJSONError {
        print("convert to json error: \(myJSONError)")
    }
    return nil
}
public func readString(fileName: String) -> String? {
    do {
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            let savedText = try String(contentsOf: fileURL)
            return savedText
        }
        return nil
    } catch {
        return nil
    }
}

public func writeString(aString: String, fileName: String) {
    do {
        
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            try aString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    } catch {
        print("\(error)")
    }
}
class Constants: NSObject {

}
