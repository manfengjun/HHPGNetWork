//
//  RxSwift+HandyJSON.swift
//  Alamofire
//
//  Created by ios on 2019/6/18.
//

import UIKit
import RxSwift
import Moya
import HandyJSON
import Result

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// JSON JSONSerialization 过滤 Code
    ///
    /// - Returns: Any
    func mapRxSpiJSON() -> Single<Any> {
        return flatMap{ response -> Single<Any> in
            return Single.just(try response.mapSpiJSON())
        }
    }
    
    /// Object: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    /// - Returns: HandyJSON
    func mapRxSpiObject<T: HandyJSON>(to type: T.Type) -> Single<T> {
        return flatMap({ response -> Single<T> in
            return Single.just(try response.mapSpiObject(type))
        })
    }
    
    /// Objects: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    /// - Returns: [HandyJSON]
    func mapRxSpiObjects<T: HandyJSON>(to type: T.Type) -> Single<[T]> {
        return flatMap( { response -> Single<[T]> in
            return Single.just(try response.mapSpiObjects(type))
        })
    }
}
