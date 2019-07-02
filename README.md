# HHPGNetWork

[![CI Status](https://img.shields.io/travis/liufengjun/HHPGNetWork.svg?style=flat)](https://travis-ci.org/liufengjun/HHPGNetWork)
[![Version](https://img.shields.io/cocoapods/v/HHPGNetWork.svg?style=flat)](https://cocoapods.org/pods/HHPGNetWork)
[![License](https://img.shields.io/cocoapods/l/HHPGNetWork.svg?style=flat)](https://cocoapods.org/pods/HHPGNetWork)
[![Platform](https://img.shields.io/cocoapods/p/HHPGNetWork.svg?style=flat)](https://cocoapods.org/pods/HHPGNetWork)

## 安装

```
pod 'HHPGNetWork'
```

## 使用说明

### 基础配置

```
PGSpiManager.config.setConfig(baseUrls: ["https://api.apiopen.top"],
                              result_key: PGSpiRegKey(code: "code",
                                                      msg: "message",
                                                      data: "data1",
                                                      success: 200))
```
### RxSwift请求
```
_ = PGSpi(Common.getAllRegion).rxSend().mapSpiObjects(to: AppInfo.self).subscribe(onSuccess: { (value) in
        print(value.count)
        print(value[0].toJSONString())
    }) { (error) in
        print(error.localizedDescription)
    }.disposed(by: disposeBag)
```
### 流请求
```
PGSpi(Common.getAllRegion).send { (response) in
    switch response.result {
        case .success(let value):
            do {
               let repos = try value.mapJSON()
            } catch(let error) {
               print(error.localizedDescription)
            }
        case .failure(let error):
            print(error.handle().message)
    }
}
```
## 作者

chinafengjun@gmail.com

## 开源协议

本项目基于 [MIT](https://zh.wikipedia.org/wiki/MIT%E8%A8%B1%E5%8F%AF%E8%AD%89) 协议，请自由地享受和参与开源。
