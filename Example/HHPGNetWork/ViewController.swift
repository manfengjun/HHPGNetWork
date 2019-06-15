//
//  ViewController.swift
//  YSHTTPSpider
//
//  Created by acct<blob>=<NULL> on 03/03/2019.
//  Copyright (c) 2019 acct<blob>=<NULL>. All rights reserved.
//

import UIKit
import Alamofire
import HHPGNetWork

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 网络库设置
        SpiManager.config.setConfig(baseUrls: ["https://api.apiopen.top"],
                                    result_key: SpiRegKey(code: "code",
                                                          msg: "message",
                                                          data: "data",
                                                          success: 200))
        // 请求示例
        Spi(Common.getAllRegion).send { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let repos = try value.mapSpiObjects(AppInfo.self)
                    print(repos.count)
                    print(repos[0].toJSONString())
                } catch(let error) {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.handle().message)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Error {
    /// 错误信息处理
    ///
    /// - Returns:
    public func handle() -> (status: Int, message: String){
        guard let error = self as? SpiError else {
            return (-1, "服务器异常，请稍后再试!")
        }
        let status = error.status ?? -1
        let message = error.message ?? "服务器异常，请稍后再试!"
        return (status, message)
    }
}
