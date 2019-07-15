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
public extension PGSpi {
    /// RxSwift 请求
    ///
    /// - Returns:
    func rxSend(_ activityIndicator: ActivityIndicator? = nil) -> Single<Response> {
        guard let activityIndicator = activityIndicator else {
            return provider.rx.request(self)
        }
        return provider.rx.request(self).trackActivity(activityIndicator).asSingle()
    }
}
