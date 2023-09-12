//
//  Constants.swift
//  Move004
//
//  Created by apple on 06/09/2023.
//

import Foundation
public let NAME_FILE_EDIT_SAVE = "list_move_save.json"

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
