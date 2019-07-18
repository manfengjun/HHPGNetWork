//
//  RxSwift+HandyJSON.swift
//  Alamofire
//
//  Created by ios on 2019/6/18.
//

import HandyJSON
import Moya
import Result
import RxSwift
import UIKit

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    /// JSON JSONSerialization 过滤 Code
    ///
    /// - Returns: Any
    func mapSpiJSON() -> Single<Any> {
        return flatMap { response -> Single<Any> in
            Single.just(try response.mapSpiJSON())
        }
    }

    /// Object: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    /// - Returns: HandyJSON
    func mapSpiObject<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            Single.just(try response.mapSpiObject(type, designatedPath: path))
        }
    }

    /// Objects: [HandyJSON]
    ///
    /// - Parameter type: HandyJSON
    /// - Returns: [HandyJSON]
    func mapSpiObjects<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            Single.just(try response.mapSpiObjects(type, designatedPath: path))
        }
    }
}
