//
//  ITRTCVideoCallInterface.swift
//  trtcScenesDemo
//
//  Created by xcoderliu on 2020/2/11.
//  Copyright © 2020 xcoderliu. All rights reserved.
//

import Foundation

@objc public enum VideoCallType : Int32, Codable {
    case unknown = 0
    case audio = 1
    case video = 2
}

// MARK: - ITRTCVideoCallInterface

/*
* TRTC 视频通话接口
* 本功能使用腾讯云实时音视频 / 腾讯云即时通信IM 组合实现
* 使用方式如下
* 1. 初始化
* TRTCVideoCall.shared.setup()
* 2. 监听回调
* TRTCVideoCall.shared.delegate = self
* 3. 登录到IM系统中
* TRTCVideoCall.shared.login(sdkAppid, A, password, success, failed)
* 4. 给B拨打电话
* TRTCVideoCall.shared.call(B)
* 5. 打开本地摄像头
* TRTCVideoCall.shared.openCamera(frontCamera: true, view: localPreView)
* 6. 接听/拒绝电话
* 此时B如果也登录了IM系统，会收到onInvited(A, null, false)回调
* B 可以调用 TRTCVideoCall.shared.accept 接受 / TRTCAudioCall.shared.reject 拒绝
* 7. 观看对方的画面
* 由于A打开了摄像头，B接受通话后会收到 onUserVideoAvailable(A, true) 回调
* B 可以调用 TRTCVideoCall.shared.startRemoteView(A, AView) 就可以看到A的画面了
* 8. 结束通话
* 需要结束通话时，A、B 任意一方可以调用 TRTCAudioCall.shared.hangup() 挂断电话
* 9. 销毁实例
* TRTCVideoCall.shared.destroy()
*/

@objc protocol TimITRTCVideoCallInterface {

    /// 回调代理
    weak var delegate: TRTCVideoCallDelegate? {get set}
    
    // MARK: - life-cycle
    
    /// 初始化函数，请在使用所有功能之前先调用该函数进行必要的初始化
    func setup()
    
    /// 销毁函数，如果不需要再运行该实例，请调用该接口
    func destroy()
    
    // MARK: - login
    
    /// 登录IM接口，所有功能需要先进行登录后才能使用
    /// - Parameters:
    ///   - sdkAppID: TRTC SDK AppID
    ///   - user: 用户名
    ///   - userSig: 用户签名
    ///   - success: 成功回调
    ///   - failed: 失败回调
    @objc func login(sdkAppID: UInt32,
                     user: String,
                     userSig: String,
                     success: @escaping (() -> Void),
                     failed: @escaping ((_ code: Int, _ message: String) -> Void))
    
    /// 登出接口，登出后无法再进行拨打操作
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failed: 失败回调
    @objc func logout(success: @escaping (() -> Void),
    failed: @escaping ((_ code: Int, _ message: String) -> Void))
    
    // MARK: - call
    
    /// c2c通话邀请
    /// - Parameters:
    ///   - userID: 用户ID | userID
    @objc func call(userID: String, type: VideoCallType)
    
    /// 群聊通话邀请
    /// - Parameters:
    ///   - userIDs: 用户ID列表 | userIDs
    ///   - groupID: 群组ID | groupID
    @objc func groupCall(userIDs: [String], type: VideoCallType, groupID: String)
    
    /// 接受当前通话 |
    ///  accept current call
    @objc func accept()
    
    /// 拒绝当前通话 |
    ///  reject cunrrent call
    @objc func reject()
    
    /// 挂断多人通话如果有人未应答就发送取消 |
    /// In a multi-person call a cancel message will be sent if there have user who not respond
    @objc func hangup()
    
    // MARK: - Device
    
    /// 当您收到 onUserVideoAvailable 回调时，可以调用该函数将远端用户的摄像头数据渲染到指定的 UIView 中
    /// - Parameters:
    ///   - userId: 远端用户id
    ///   - view: 远端用户数据将渲染到该view中
    @objc func startRemoteView(userId: String, view: UIView)
    
    /// 当您收到 onUserVideoAvailable 回调为false时，可以停止渲染数据
    /// - Parameter userId: 远端用户id
    @objc func stopRemoteView(userId: String)
    
    /// 您可以调用该函数开启摄像头，并渲染在指定的 UIView 中
    /// - Parameters:
    ///   - frontCamera: 是否开启前置摄像头
    ///   - view: 摄像头的数据将渲染到该view中
    @objc func openCamera(frontCamera: Bool, view: UIView)
    
    /// 您可以调用该函数关闭摄像头
    /// 处于通话中的用户会收到 onUserVideoAvailable 回调
    @objc func closeCamara()
    
    /// 您可以调用该函数切换前后摄像头
    /// - Parameter frontCamera: true:切换前置摄像头 false:切换后置摄像头
    @objc func switchCamera(frontCamera: Bool)
    
    /// isMute true:麦克风关闭 false:麦克风打开 |
    /// isMute true:micphone will be closed  false:micphone will be open
    @objc func setMicMute(isMute: Bool)
    
    /// isHandsFree true:开启免提 false:关闭免提 |
    /// isHandsFree true:Hands Free false:Headset
    @objc func setHandsFree(isHandsFree: Bool)
}
