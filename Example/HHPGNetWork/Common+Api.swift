//
//  Api+Common.swift
//  WTDistributorVersion
//
//  Created by ios on 2018/6/28.
//  Copyright © 2018年 ios. All rights reserved.
//
import UIKit
import Alamofire
import HHPGNetWork
enum Common {
    // MARK: - 获取地址三级分类数据
    case getAllRegion
    
    
}
extension Common : SpiTarget {
    var headers: HTTPHeaders? {
        return [:]
    }
    var baseURL: String {
        return "https://api.apiopen.top"
    }
    var path: String {
        switch self {
        case .getAllRegion: return "/searchPoetry"
        
        }
    }
    var method: HTTPMethod {
        return .get
    }
    var parameters: Parameters? {
        switch self {
        case .getAllRegion:
            return ["name":"月"]
        
        }
    }
    
}
