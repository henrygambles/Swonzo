//
//  SwonzoOAuth.swift
//  Swonzo
//
//  Created by Henry Gambles on 22/09/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire


class OAuth2RetryHandler: RequestRetrier, RequestAdapter {
    
    let loader: OAuth2DataLoader
    
    init(oauth2: OAuth2) {
        loader = OAuth2DataLoader(oauth2: oauth2)
    }
    
//    let sessionManager = SessionManager()
//    let retrier = OAuth2RetryHandler(oauth2: <# your OAuth2 instance #>)
//    sessionManager.adapter = retrier
//    sessionManager.retrier = retrier
//    self.alamofireManager = sessionManager   // you must hold on to this somewhere
//    
//    sessionManager.request("https://api.github.com/user").validate().responseJSON { response in
//    debugPrint(response)
//    }
    
    /// Intercept 401 and do an OAuth2 authorization.
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize() { authParams, error in
                guard error?.asOAuth2Error != .alreadyAuthorizing else {
                    // Don't dequeue requests if we are waiting for other authorization request
                    return
                }
                self.loader.dequeueAndApply() { req in
                    if let comp = req.context as? RequestRetryCompletion {
                        comp(nil != authParams, 0.0)
                    }
                }
            }
        }
        else {
            completion(false, 0.0)   // not a 401, not our problem
        }
    }
    
    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard nil != loader.oauth2.accessToken else {
            return urlRequest
        }
        return try urlRequest.signed(with: loader.oauth2)   // "try" added in 3.0.2
    }
}
