

import Foundation
import UIKit
// For request API
let apiHost = "https://api.themoviedb.org"
let imageHost = "https://image.tmdb.org/t/p/w500"
class ApiDefines: NSObject{
    class func movieTopRated() -> String {
        return "\(apiHost)/3/movie/top_rated"
    }
    class func movieSeach() -> String {
        return "\(apiHost)/3/search/movie"
    }
  
 
}
