//
//  MethodChannelFactory.swift
//  Runner
//
//  Created by Andres Duque on 28/02/23.
//

import Foundation
import Flutter

struct MethodChannelFactory {
    static func get(type: MethodChannels, controller: FlutterViewController) -> MethodChannel {
        
        let methodChannel = FlutterMethodChannel(
            name: type.rawValue,
            binaryMessenger: controller.binaryMessenger
        )
        
        switch type {
            case .musicPlayer: return MusicPlayerMethodChannel(methodChannel: methodChannel)
        }
    }
}
