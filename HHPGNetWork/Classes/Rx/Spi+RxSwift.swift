//
//  Spi+RxSwift.swift
//  Alamofire
//
//  Created by ios on 2019/6/18.
//

import UIKit
import Moya
import RxSwift
import Result
public extension Spi {
    
    /// RxSwift 请求
    ///
    /// - Returns:
    func sendRx() -> Single<Response>{
        let provider = target.logEnable ? asProvider().log : asProvider()
        return provider.rx.request(self)
    }
}
