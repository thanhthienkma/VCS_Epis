//
//  Permission.swift
//  utils
//
//  Created by Nguyen Nam on 4/7/20.
//

import Photos
import Foundation
class Permission:NSObject{
    
    // Check photo library permission
    // 1: authorized
    // 2: notDetermined
    // 3: denied, restricted
    func checkPhotoLibraryPermission()->Int{
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return 1;
        case .denied, .restricted :
            return 3;
        case .notDetermined:
            return 2;
        @unknown default:
            return 3;
        }
    }
    
    // Request photo library permission
    // 1: Success
    // 2: Denied
    func requestPhotoLibraryPermission(completion: @escaping (Int) -> Void){
        //        PHPhotoLibrary.cancelPreviousPerformRequests(withTarget: Any)
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(1)
                break
            // as above
            case .denied, .restricted:
                completion(2)
                break
            // as above
            case .notDetermined:
                completion(2)
                break
            // won't happen but still
            @unknown default:
                completion(2)
                break
            }
        }
    }

    
    // Request photo library permission
    // 1: authorized
    // 2: notDetermined
    // 3: denied, restricted
    func checkCameraPermission()->Int{
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            return 3;
        case .restricted:
            return 3
        case .authorized:
            return 1;
        case .notDetermined:
            return 2;
        @unknown default:
            return 3;
        }
    }
    // Request camera permission
    // 1: Success
    // 2: Denied
    func requestCameraPermission(completion: @escaping (Int) -> Void){
        
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                completion(1)
            } else {
                completion(2)
            }
        }
    }
    
}

