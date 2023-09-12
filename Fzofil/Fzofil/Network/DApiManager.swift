//
//  DApiManager.swift
//  demo3
//
//  Created by apple on 30/08/2022.
//

import Foundation
import SwiftUI

fileprivate enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
let apiKey = "7ee59323be031d45f543f8c0809f4b6b"

// khoi tao
typealias ApiCompletion = (_ data: DResponse) -> ()
typealias DDictionary = [String: Any]

class DApiManage: NSObject{
    private let TIMEOUT_REQUEST: TimeInterval = 30
    
    // create Instance
    static let getInstance: DApiManage = DApiManage()
    
    fileprivate func request(urlString: String,
                             param: DDictionary,
                             headers: [String: String]?,
                             method: HttpMethod,
                             showLoading: Bool,
                             completion: ApiCompletion?
    ){
        //showloading
        var request:URLRequest!
        
        // set method & param
        if method == .get{
            if param.keys.count > 0{
                let parameterString = param.stringFromHttpParameters()
                request = URLRequest(url: URL(string:"\(urlString)?\(parameterString)")!)
            }
            else{
                request = URLRequest(url: URL(string:urlString)!)
            }
            if let headers = headers {
                request.allHTTPHeaderFields = headers
            }
        }
        else if method == .post || method == .put || method == .delete {
            request = URLRequest(url: URL(string:urlString)!)
            
            // content-type
            if let headers = headers {
                request.allHTTPHeaderFields = headers
            }
            else {
                //?
                request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            }
            
            let body = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            request.httpBody = body
        }
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = method.rawValue
        
        // call api
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // handle error 401
                if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                    return
                }
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    if let block = completion {
                        let data = DResponse(error: error?.localizedDescription)
                        block(data)
                    }
                    return
                }
                
                //
                if let block = completion {
                    if let json = self.dataToJSON(data: data) {
                        let data = DResponse(true, data: json)
                        block(data)
                    }
                    else if let stringJson = String(data: data, encoding: .utf8) {
                        print("stringJson: \(stringJson)")
                        let data = DResponse(true, data: nil)
                        block(data)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    private func createBody(parameters: DDictionary,
                            boundary: String,
                            images: [UIImage],
                            field: String,
                            mimeType: String) -> Data
    {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        var index = 0
        for img in images {
            if let data = img.pngData() {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(index)\"\r\n")
                body.appendString("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")
                index += 1
            }
        }
        
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    private func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch { }
        return nil
    }
}
extension DApiManage{
    func getMovieTopRate(page: Int, showLoading: Bool, completion: @escaping ApiCompletion) {
        let url = ApiDefines.movieTopRated()
        let params: DDictionary = ["api_key": apiKey, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: showLoading) { (response) in
            if let data = response.data as? DDictionary {
                do {
                    if(data.keys.contains(where: { item in
                        return item == "results"
                    })) {
                        let listDataMovie = data["results"] as! [DDictionary]
                        var listMovie = [DMoviesDetail]()
                        for item in listDataMovie {
                            let movie = DMoviesDetail(item)
                            listMovie.append(movie)
                        }
                        let res = DResponse(true, data: listMovie)
                        completion(res)
                        return
                    }
                   
                }catch{
                    
                }
                
            }
        }
    }
    
    func getSeachMove(showLoading: Bool,txtSeach: String,page: Int, completion: @escaping ApiCompletion){
        let url = ApiDefines.movieSeach()
        let param: DDictionary = ["api_key": apiKey,
                                  "query":txtSeach,
                                  "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: param, headers: headers, method: .get, showLoading: showLoading) { response in
            if let data = response.data as? DDictionary{
                do {
                    if(data.keys.contains(where: { item in
                        return item == "results"
                    })) {
                        let listPeopleData = data["results"] as! [DDictionary]
                        var listPeople = [DMoviesDetail]()
                        for item in listPeopleData{
                            let people = DMoviesDetail(data: item)
                            listPeople.append(people)
                        }
                        let res = DResponse(true, data: listPeople)
                        completion(res)
                        return
                    }
                
                }catch {
                    
                }
            }
        }
    }
}


