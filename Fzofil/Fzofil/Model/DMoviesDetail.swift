import UIKit

class DMoviesDetail: NSObject {

    var backdrop_path: String = ""//
    var original_title: String = ""
    var poster_path: String = ""
    var title: String = ""
    var nameIcon: String = "Wow"
    var timeWatch: String = ""
    var txtNote: String = ""
    var year: Int = 0
    override init() {
        
    }
    func toString() -> [String: Any] {
        return ["backdrop_path": backdrop_path,
                "original_title": original_title,
                "poster_path": poster_path,
                "title": title,
                "nameIcon": nameIcon,
                "timeWatch": timeWatch,
                "txtNote": txtNote,
                "year":year]
    }
    
    init(data: [String: Any]) {
        if let val = data["poster_path"] as? String { poster_path = val }
        if let val = data["backdrop_path"] as? String { backdrop_path = val }
        if let val = data["original_title"] as? String { original_title = val }
        if let val = data["title"] as? String { title = val }
        if let val = data["nameIcon"] as? String { nameIcon = val }
        if let val = data["timeWatch"] as? String { timeWatch = val }
        if let val = data["txtNote"] as? String { txtNote = val }
        if let val = data["year"] as? Int { year = val }
    }
    
    init(_ dictionary: DDictionary) {
        if let val = dictionary["poster_path"] as? String { poster_path = val }
        if let val = dictionary["backdrop_path"] as? String { backdrop_path = val }
        if let val = dictionary["original_title"] as? String { original_title = val }
        if let val = dictionary["title"] as? String { title = val }
        if let val = dictionary["nameIcon"] as? String { nameIcon = val }
        if let val = dictionary["timeWatch"] as? String { timeWatch = val }
        if let val = dictionary["txtNote"] as? String { txtNote = val }
        if let val = dictionary["year"] as? Int { year = val }
    }
}
extension DMoviesDetail{
    static func readFromFileEditJson() -> [DMoviesDetail] {
        let string = readString(fileName: NAME_FILE_EDIT_SAVE)
        if string == nil || string == "" {
            return [DMoviesDetail]()
        }
        let data: [DDictionary] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [DMoviesDetail]()
        for item in data {
            let model = DMoviesDetail(item)
            result.append(model)
        }
        return result
    }
}
