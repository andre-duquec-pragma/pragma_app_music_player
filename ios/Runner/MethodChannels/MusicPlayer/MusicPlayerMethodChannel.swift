//
//  MusicPlayerMethodChannel.swift
//  Runner
//
//  Created by Andres Duque on 28/02/23.
//

import Foundation
import Flutter

class MusicPlayerMethodChannel: MethodChannel {
    private let methodChannel: FlutterMethodChannel
    
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    
    func startListening() {
        methodChannel.setMethodCallHandler { call, result in
            switch call.method {
            case MusicPlayerMethods.prepareForReproduceInBackground.rawValue:
                self.handleReproduceInBackgroundCall(arguments: call.arguments)
            case MusicPlayerMethods.prepareForReproduceInForeground.rawValue:
                self.handleReproduceInForegroundCall()
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func handleReproduceInBackgroundCall(arguments: Any?) {
        print("::: HANDLE REPRODUCE IN BACKGROUND (iOS)")
 
        guard let arguments = arguments as? [String: Any] else { return }
        
        let data = PlayListSong(from: arguments)
        
        print("::: CURRENT SONG \(data.name ?? "") :::")
    }
    
    private func handleReproduceInForegroundCall() {
        print("::: HANDLE REPRODUCE IN FOREGROUND (iOS)")
    }
}
