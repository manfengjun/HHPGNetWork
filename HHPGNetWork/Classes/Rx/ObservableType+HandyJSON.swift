//
//  ObservableType+HandyJSON.swift
//  Alamofire
//
//  Created by JUN on 2019/7/17.
//

import UIKit

import Foundation
import HandyJSON
import Moya
import RxSwift

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {
    /// JSON JSONSerialization 过滤 Code
    ///
    /// - Returns: Any
    func mapSpiJSON() -> Observable<Result<Any, PGSpiError>> {
        return flatMap { response -> Observable<Result<Any, PGSpiError>> in
            do {
                return Observable.just(Result.success(try response.mapSpiJSON()))
            } catch {
                if error is PGSpiError {
                    return Observable.just(Result<Any, PGSpiError>.failure(error as! PGSpiError))
                } else {
                    return Observable.just(Result<Any, PGSpiError>.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                }
            }
        }.catchErrorJustReturn(Result<Any, PGSpiError>.failure(PGSpiError.requestException(exception: .networkException(nil))))
    }

    /// Object: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    ///   - path: 路径
    /// - Returns: HandyJSON
    func mapSpiObject<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Observable<Result<T, PGSpiError>> {
        return flatMap { response -> Observable<Result<T, PGSpiError>> in
            do {
                return Observable.just(Result.success(try response.mapSpiObject(type, designatedPath: path)))
            } catch {
                if error is PGSpiError {
                    return Observable.just(Result<T, PGSpiError>.failure(error as! PGSpiError))
                } else {
                    return Observable.just(Result<T, PGSpiError>.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                }
            }
        }.catchErrorJustReturn(Result<T, PGSpiError>.failure(PGSpiError.requestException(exception: .networkException(nil))))
    }

    /// Objects: [HandyJSON]
    ///
    /// - Parameter type: HandyJSON
    ///   - path: 路径
    /// - Returns: [HandyJSON]
    func mapSpiObjects<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Observable<Result<[T], PGSpiError>> {
        return flatMap { response -> Observable<Result<[T], PGSpiError>> in
            do {
                return Observable.just(Result.success(try response.mapSpiObjects(type, designatedPath: path)))
            } catch {
                if error is PGSpiError {
                    return Observable.just(Result<[T], PGSpiError>.failure(error as! PGSpiError))
                } else {
                    return Observable.just(Result<[T], PGSpiError>.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                }
            }
        }.catchErrorJustReturn(Result<[T], PGSpiError>.failure(PGSpiError.requestException(exception: .networkException(nil))))
    }
}
