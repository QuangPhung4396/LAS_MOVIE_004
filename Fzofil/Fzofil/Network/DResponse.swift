//
//  Dresponse.swift
//  demo3
//
//  Created by apple on 29/08/2022.
//

import CoreGraphics


class DResponse: NSObject{
    var success: Bool = false
    var error: String?
    var data: Any?
    
    init(_success: Bool, _data: Any?, _error: String){
        self.success = _success
        self.error = _error
        self.data = _data
    }
    init(_ success: Bool, data: Any?) {
        self.success = success
        self.data = data
    }
    
    init(error: String?) {
        self.success = false
        self.error = error
    }
}
