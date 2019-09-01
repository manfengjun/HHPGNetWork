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
    
    /// RxSwift
    ///
    /// - Parameter activityIndicator: ActivityIndicator
    /// - Returns: Observable<Response>
    func observable(_ activityIndicator: ActivityIndicator? = nil) -> Observable<Response> {
        let observable = provider.rx.request(self).asObservable()
        if let activityIndicator = activityIndicator {
            return observable.trackActivity(activityIndicator)
        }
        return observable
    }
    
    /// RxSwift
    /// - Parameter activityIndicator: ActivityIndicator
    /// - Returns: Driver<Response>
    func driver(_ activityIndicator: ActivityIndicator? = nil) -> Driver<Response> {
        let observable = provider.rx.request(self).asObservable()
        if let activityIndicator = activityIndicator {
            return observable.trackActivity(activityIndicator).asDriver(onErrorJustReturn: Response(statusCode: -1, data: Data()))
        }
        return observable.asDriver(onErrorJustReturn: Response(statusCode: -1, data: Data()))
    }
}
