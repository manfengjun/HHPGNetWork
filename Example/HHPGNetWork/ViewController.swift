//
//  ViewController.swift
//  YSHTTPSpider
//
//  Created by acct<blob>=<NULL> on 03/03/2019.
//  Copyright (c) 2019 acct<blob>=<NULL>. All rights reserved.
//

import UIKit
import HHPGNetWork
import Moya
import RxSwift
let disposeBag = DisposeBag()
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 网络库设置
        PGSpiManager.config.setConfig(baseUrls: ["https://api.apiopen.top"],
                                    result_key: PGSpiRegKey(code: "code",
                                                          msg: "message",
                                                          data: "data",
                                                          success: 200))

        // RxSwift请求示例
        PGSpi(Common.getAllRegion).rxSend(ActivityIndicator()).mapSpiObjects(to: AppInfo.self).subscribe(onSuccess: { (value) in
            print(value.count)
            print(value[0].toJSONString())
        }) { (error) in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
        
//        // 流请求示例
//        PGSpi(Common.getAllRegion).send { (response) in
//            switch response.result {
//            case .success(let value):
//                do {
//                    let repos = try value.mapJSON()
//                } catch(let error) {
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                print(error.handle().message)
//            }
//        }
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
        guard let error = self as? PGSpiError else {
            return (-1, "服务器异常，请稍后再试!")
        }
        let status = error.status ?? -1
        let message = error.message ?? "服务器异常，请稍后再试!"
        return (status, message)
    }
}
