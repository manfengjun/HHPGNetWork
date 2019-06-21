//
//  PGSpi.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import Alamofire
import Moya
import UIKit
private let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<PGSpi>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = PGSpiManager.config.timeoutInterval
        done(.success(request))
    } catch {
        return
    }
}

public class PGSpi: NSObject {
    public let target: PGSpiTarget
    let provider = MoyaProvider<PGSpi>(requestClosure: requestClosure, plugins: [PGSpiLogger()])
    public init(_ target: PGSpiTarget) {
        self.target = target
    }
    
    // MARK: - 发送请求
    
    public func send(completion: @escaping Completion) {
        let PGSpiProvider = target.logEnable ? provider.log : provider
        PGSpiProvider.request(self, completion: completion)
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
