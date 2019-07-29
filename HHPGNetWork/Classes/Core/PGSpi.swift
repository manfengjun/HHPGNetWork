//
//  PGSpi.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import Moya
import UIKit
import Result
private let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<PGSpi>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = PGSpiManager.config.timeoutInterval
        done(.success(request))
    } catch {
        return
    }
}
public typealias Completion = (_ result: Result<Moya.Response, Error>) -> Void
public class PGSpi: NSObject {
    public let target: PGSpiTarget
    let provider = MoyaProvider<PGSpi>(requestClosure: requestClosure, plugins: [PGSpiLogger()])
    public init(_ target: PGSpiTarget) {
        self.target = target
    }
    
    // MARK: - 发送请求
    func asProvider() -> MoyaProvider<PGSpi> {
        return target.logEnable ? provider.log : provider
    }
    
}
extension PGSpi: TargetType {
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var baseURL: URL {
        return try! target.asURL()
    }
    
    public var path: String {
        return target.path
    }
    
    public var method: Moya.Method {
        return target.method
    }
    public var headers: [String: String]? {
        return target.headers
    }
    
    public var task: Task {
        guard let parameters = target.parameters else { return .requestPlain }
        if method == .get {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        } else {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
