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
    func mapSpiJSON() -> Observable<Result<Any,PGSpiError>> {
        return flatMap { response -> Observable<Result<Any,PGSpiError>> in
            do {
                return Observable.just(Result.success(try response.mapSpiJSON()))
            } catch(let error) {
                if error is PGSpiError {
                    return Observable.just(Result<Any, PGSpiError>.failure(error as! PGSpiError))
                }
                else {
                    return Observable.just(Result<Any, PGSpiError>.failure(PGSpiError.parameterEncodingFailed(reason: .jsonEncodingFailed(error))))
                }
            }
        }
    }
    
    /// Object: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    ///   - path: 路径
    /// - Returns: HandyJSON
    func mapSpiObject<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Observable<Result<T,PGSpiError>>  {
        return flatMap { response -> Observable<Result<T,PGSpiError>> in
            do {
                return Observable.just(Result.success(try response.mapSpiObject(type, designatedPath: path)))
            } catch(let error) {
                if error is PGSpiError {
                    return Observable.just(Result<T, PGSpiError>.failure(error as! PGSpiError))
                }
                else {
                    return Observable.just(Result<T, PGSpiError>.failure(PGSpiError.parameterEncodingFailed(reason: .jsonEncodingFailed(error))))
                }
            }
        }
    }
    
    /// Objects: [HandyJSON]
    ///
    /// - Parameter type: HandyJSON
    ///   - path: 路径
    /// - Returns: [HandyJSON]
    func mapSpiObjects<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Observable<Result<[T],PGSpiError>>  {
        return flatMap { response -> Observable<Result<[T],PGSpiError>> in
            do {
                return Observable.just(Result.success(try response.mapSpiObjects(type, designatedPath: path)))
            } catch(let error) {
                if error is PGSpiError {
                    return Observable.just(Result<[T], PGSpiError>.failure(error as! PGSpiError))
                }
                else {
                    return Observable.just(Result<[T], PGSpiError>.failure(PGSpiError.parameterEncodingFailed(reason: .jsonEncodingFailed(error))))
                }
            }
        }
    }
    //    /// JSON JSONSerialization 过滤 Code
    //    ///
    //    /// - Returns: Any
    //    func mapSpiJSON() -> Observable<Any> {
    //        return flatMap { response -> Observable<Any> in
    //            Observable.just(try response.mapJSON())
    //        }
    //    }
    //
    //    /// Object: HandyJSON
    //    ///
    //    /// - Parameter type: HandyJSON
    //    /// - Returns: HandyJSON
    //    func mapSpiObject<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Observable<T> {
    //        return flatMap { response -> Observable<T> in
    //            Observable.just(try response.mapSpiObject(type, designatedPath: path))
    //        }
    //    }
    //
    //    /// Objects: [HandyJSON]
    //    ///
    //    /// - Parameter type: HandyJSON
    //    /// - Returns: [HandyJSON]
    //    func mapSpiObjects<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Observable<[T]> {
    //        return flatMap { response -> Observable<[T]> in
    //            Observable.just(try response.mapSpiObjects(type, designatedPath: path))
    //        }
    //    }
}
