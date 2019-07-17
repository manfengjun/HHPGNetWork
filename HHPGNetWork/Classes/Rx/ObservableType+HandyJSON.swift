//
//  ObservableType+HandyJSON.swift
//  Alamofire
//
//  Created by JUN on 2019/7/17.
//

import UIKit

import Foundation
import RxSwift
import Moya
import HandyJSON

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {
    /// JSON JSONSerialization 过滤 Code
    ///
    /// - Returns: Any
    func mapSpiJSON() -> Observable<Any> {
        return flatMap { response -> Observable<Any> in
            Observable.just(try response.mapJSON())
        }
    }
    
    /// Object: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    /// - Returns: HandyJSON
    func mapSpiObject<T: HandyJSON>(to type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.mapSpiObject(type))
        }
    }
    
    /// Objects: [HandyJSON]
    ///
    /// - Parameter type: HandyJSON
    /// - Returns: [HandyJSON]
    func mapSpiObjects<T: HandyJSON>(to type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.mapSpiObjects(type))
        }
    }
}
