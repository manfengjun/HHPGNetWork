//
//  Driver+HandyJSON.swift
//  ActiveLabel
//
//  Created by JUN on 2019/9/1.
//

import Foundation
import HandyJSON
import Moya
import RxCocoa
import RxSwift

public extension Driver where E == Response {
    /// JSON JSONSerialization 过滤 Code
    ///
    /// - Returns: Any
    func mapSpiJSON() -> Driver<Result<Any, PGSpiError>> {
        return flatMap { response -> Driver<Result<Any, PGSpiError>> in
            do {
                return Driver.just(Result.success(try response.mapSpiJSON()))
            } catch {
                if error is PGSpiError {
                    return Driver.just(Result<Any, PGSpiError>.failure(error as! PGSpiError))
                } else {
                    return Driver.just(Result<Any, PGSpiError>.failure(PGSpiError.responseException(exception: PGSpiError.ResponseException.serverException)))
                }
            }
        }
    }

    /// Object: HandyJSON
    ///
    /// - Parameter type: HandyJSON
    ///   - path: 路径
    /// - Returns: HandyJSON
    func mapSpiObject<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Driver<Result<T, PGSpiError>> {
        return flatMap { response -> Driver<Result<T, PGSpiError>> in
            do {
                return Driver.just(Result.success(try response.mapSpiObject(type, designatedPath: path)))
            } catch {
                if error is PGSpiError {
                    return Driver.just(Result<T, PGSpiError>.failure(error as! PGSpiError))
                } else {
                    return Driver.just(Result<T, PGSpiError>.failure(PGSpiError.responseException(exception: PGSpiError.ResponseException.serverException)))
                }
            }
        }
    }

    /// Objects: [HandyJSON]
    ///
    /// - Parameter type: HandyJSON
    ///   - path: 路径
    /// - Returns: [HandyJSON]
    func mapSpiObjects<T: HandyJSON>(to type: T.Type, path: String? = nil) -> Driver<Result<[T], PGSpiError>> {
        return flatMap { response -> Driver<Result<[T], PGSpiError>> in
            do {
                return Driver.just(Result.success(try response.mapSpiObjects(type, designatedPath: path)))
            } catch {
                if error is PGSpiError {
                    return Driver.just(Result<[T], PGSpiError>.failure(error as! PGSpiError))
                } else {
                    return Driver.just(Result<[T], PGSpiError>.failure(PGSpiError.responseException(exception: PGSpiError.ResponseException.serverException)))
                }
            }
        }
    }
}
