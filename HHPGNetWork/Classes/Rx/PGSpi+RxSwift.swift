//
//  PGSpi+RxSwift.swift
//  Alamofire
//
//  Created by ios on 2019/6/18.
//

import Moya
import Result
import RxSwift
import UIKit
import RxCocoa
public extension PGSpi {
    /// RxSwift 请求
    ///
    /// - Returns: Single<Response>
    func single() -> Single<Response> {
        return provider.rx.request(self)
    }
    
    /// RxSwift 请求
    ///
    /// - Parameter activityIndicator: 请求状态
    /// - Returns: Observable<Response>
    func observable(_ activityIndicator: ActivityIndicator? = nil) -> Observable<Response> {
        let observable = provider.rx.request(self).asObservable()
        if let activityIndicator = activityIndicator {
            return observable.trackActivity(activityIndicator)
        }
        return observable
    }
}
