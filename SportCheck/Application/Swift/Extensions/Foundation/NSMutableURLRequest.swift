//
//  NSURLRequest.swift
//  SportCheck
//
//  Created by Alexey Meleshkevich on 03.09.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    internal convenience init(createRequestFrom requestModel: RequestModel) {
        self.init()
        url = requestModel.url
        cachePolicy = requestModel.cachePolicy
        timeoutInterval = requestModel.timeoutInterval
        httpMethod = requestModel.httpMethod
        allHTTPHeaderFields = requestModel.headers
    }
}
