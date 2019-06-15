//
//  Api+Common.swift
//  WTDistributorVersion
//
//  Created by ios on 2018/6/28.
//  Copyright © 2018年 ios. All rights reserved.
//
import UIKit
import Moya
import HHPGNetWork
enum Common {
    // MARK: - 获取地址三级分类数据
    case getAllRegion
    
    
}
extension Common : SpiTarget {
    var path: String {
        switch self {
        case .getAllRegion: return "/satinApi"
            
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAllRegion:
            return ["type":1,"page":1]
            
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    var baseURL: String {
        return "https://www.apiopen.top"
    }
    
    
}
