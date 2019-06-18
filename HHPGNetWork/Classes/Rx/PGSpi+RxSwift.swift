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
    func rxSend() -> Single<Response> {
        return provider.rx.request(self)
    }
}
