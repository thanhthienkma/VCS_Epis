import Flutter
import UIKit
import Photos
@available(iOS 9, *)
public class SwiftUtilsPlugin: NSObject, FlutterPlugin, URLSessionDownloadDelegate {
    
    static let CHANNEL = "utils"
    let CHECK_PERMISSION_METHOD = "check_permission_method"
    let REQUEST_PERMISSION_METHOD = "request_permission_method"
    let OPEN_SETTING_APP_METHOD = "open_setting_app_method"
    let THUMBNAIL_METHOD = "thumbnail_method"
    let ALL_PHOTOS_METHOD = "all_photos_method"
    let SHARE_PHOTO_METNOD = "share_photo_method"
    let DOWNLOAD_FILE_METHOD = "download_file_method"
    
    let SAVE_INT_VALUE_METHOD = "save_int_value_method"
    let GET_INT_VALUE_METHOD = "get_int_value_method"
    let SAVE_DOUBLE_VALUE_METHOD = "save_double_value_method"
    let GET_DOUBLE_VALUE_METHOD = "get_double_value_method"
    let SAVE_BOOL_VALUE_METHOD = "save_bool_value_method"
    let GET_BOOL_VALUE_METHOD = "get_bool_value_method"
    let SAVE_STRING_VALUE_METHOD = "save_string_value_method"
    let GET_STRING_VALUE_METHOD = "get_string_value_method"
    let REMOVE_VALUE_METHOD = "remove_value_method"
    let PHOTO_PATH_METHOD = "photo_path_method"
    
    let IOS_PHOTO_LIBRARY = "ios.photo_library"
    let IOS_CAMERA = "ios.camera"
    
    let KEY = "key"
    let VALUE = "value"
    
    
    var result: FlutterResult!
    let permission = Permission()
    var binaryMessenger: FlutterBinaryMessenger!
    
    var fileSize:Int64 = 0
    var fileName:String = ""
    
    
    public init(binaryMessenger: FlutterBinaryMessenger){
        super.init()
        self.binaryMessenger = binaryMessenger
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name:CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftUtilsPlugin(binaryMessenger:registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        self.result = result
        if call.method == self.REMOVE_VALUE_METHOD{
            let arguments = call.arguments as! String
            self.handleRemoveValue(key: arguments)
        }else if call.method == self.SAVE_INT_VALUE_METHOD{
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            self.handleSetIntValue(arguments: arguments)
        }else if call.method == self.GET_INT_VALUE_METHOD{
            self.handleGetIntValue(key: call.arguments as! String)
        }else if call.method == self.SAVE_DOUBLE_VALUE_METHOD{
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            self.handleSetDoubleValue(arguments: arguments)
        }else if call.method == self.GET_DOUBLE_VALUE_METHOD{
            self.handleGetDoubleValue(key: call.arguments as! String)
        }else if call.method == self.SAVE_BOOL_VALUE_METHOD{
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            self.handleSetBoolValue(arguments: arguments)
        }else if call.method == self.GET_BOOL_VALUE_METHOD{
            self.handleGetBoolValue(key: call.arguments as! String)
        }else if call.method == self.SAVE_STRING_VALUE_METHOD{
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            self.handleSetStringValue(arguments: arguments)
        }else if call.method == self.GET_STRING_VALUE_METHOD{
            self.handleGetStringValue(key: call.arguments as! String)
        }else if call.method == self.CHECK_PERMISSION_METHOD{
            self.handleCheckPermission( args: call.arguments as! [String])
        }else if call.method == self.REQUEST_PERMISSION_METHOD {
            self.handleRequestPermission(args: call.arguments as! [String])
        }else if call.method == self.OPEN_SETTING_APP_METHOD {
            self.handleOpenAppSetting()
        }else if call .method == self.THUMBNAIL_METHOD {
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            self.handleThumbnail(arguments: arguments)
        }else if call.method == self.ALL_PHOTOS_METHOD{
            self.handleAllPhotos()
        }else if call.method == self.DOWNLOAD_FILE_METHOD{
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            fileSize = arguments["file_size"] as! Int64
            fileName = arguments["file_name"] as! String
            let rawUrl = arguments["url"] as! String
            let urlString = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if let fileUrl = URL(string: urlString){
                download(from: fileUrl)
            }
            self.result("")
        }else if call.method == self.PHOTO_PATH_METHOD{
            self.handlePath(identifer: call.arguments as! String)
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
   // MARK: Handle share photo
    func handleCopyShareDocument(path: String) {
        let url = URL(fileURLWithPath: path)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
        }) { (success, error) in
            if success {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
                fetchOptions.fetchLimit = 1
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                let asset = fetchResult.firstObject
                let photo = Photo()
                photo.identifier = asset?.localIdentifier
                asset?.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
                    if (input?.fullSizeImageURL) != nil{
                        var string = input?.fullSizeImageURL?.absoluteString
                        string = string?.replacingOccurrences(of: "file://", with: "")
                        photo.path = string
                    }
                    do {
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(photo)
                        let json = String(data: jsonData, encoding: String.Encoding.utf8)
                        self.result(json)
                    } catch {
                        print("The file could not be loaded")
                        self.result("")
                    }
                }
            } else {
                self.result("")
            }
        }
    }
    
    // MARK: Handle share photo
    func handleSharePhoto(path: String) {
        let url = URL(fileURLWithPath: path)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
        }) { (success, error) in
            if success {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
                fetchOptions.fetchLimit = 1
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                let asset = fetchResult.firstObject
                let photo = Photo()
                photo.identifier = asset?.localIdentifier
                asset?.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
                    if (input?.fullSizeImageURL) != nil{
                        var string = input?.fullSizeImageURL?.absoluteString
                        string = string?.replacingOccurrences(of: "file://", with: "")
                        photo.path = string
                    }
                    do {
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(photo)
                        let json = String(data: jsonData, encoding: String.Encoding.utf8)
                        self.result(json)
                    } catch {
                        print("The file could not be loaded")
                        self.result("")
                    }
                }
            } else {
                self.result("")
            }
        }
    }
    
   // MARK: Handle remove value
    func handleRemoveValue(key:String){
        Preference.shared.remove(forKey: key)
        self.result(true)
    }
    
    // MARK: Handle set int value
    func handleSetIntValue(arguments:Dictionary<String, AnyObject>){
        let key = arguments[KEY] as! String
        let value = arguments[VALUE] as! Int
        Preference.shared.setInt(value, forKey: key)
        self.result(true)
    }
    
  // MARK: Handle get int value
    func handleGetIntValue(key:String){
        let value = Preference.shared.getInt(key)
        self.result(value)
    }
    
    // MARK: Handle set double value
    func handleSetDoubleValue(arguments:Dictionary<String, AnyObject>){
        let key = arguments[KEY] as! String
        let value = arguments[VALUE] as! Double
        Preference.shared.setDouble(value, forKey: key)
        self.result(true)
    }
    
    // MARK: Handle get double value
    func handleGetDoubleValue(key:String){
        let value = Preference.shared.getDouble(key)
        self.result(value)
    }
    
    // Handle set bool value
    func handleSetBoolValue(arguments:Dictionary<String, AnyObject>){
        let key = arguments[KEY] as! String
        let value = arguments[VALUE] as! Bool
        Preference.shared.setBool(value, forKey: key)
        self.result(true)
    }
    
    // MARK: Handle get bool value
    func handleGetBoolValue(key:String){
        let value = Preference.shared.getBool(key)
        self.result(value)
    }
    
   // MARK: Handle set string value
    func handleSetStringValue(arguments:Dictionary<String, AnyObject>){
        let key = arguments[KEY] as! String
        let value = arguments[VALUE] as! String
        Preference.shared.setString(value, forKey: key)
        self.result(true)
    }
    
    // MARK: Handle get string value
    func handleGetStringValue(key:String){
        let value = Preference.shared.getString(key)
        self.result(value)
    }
    
    func handlePath(identifer:String){
        let photo = Photo()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [identifer], options: fetchOptions)
        guard let asset = assets.firstObject else {
            self.result("")
            return
        }
        
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
            if (input?.fullSizeImageURL) != nil{
                var string = input?.fullSizeImageURL?.absoluteString
                string = string?.replacingOccurrences(of: "file://", with: "")
                photo.path = string
                photo.identifier = identifer
            }
            
            
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(photo)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)
                self.result(json)
                print("handleAllPhotos 3")
                print("Json \(json ?? "")")
            } catch {
                print("handleAllPhotos 4")
                print("The file could not be loaded")
                self.result("")
            }
        }
        
        
    }
    
    
    // MARK: Handle all photos
    func handleAllPhotos(){
        print("handleAllPhotos 1")
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        //        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        print("handleAllPhotos 2")
        var resValues:[Photo] = []
        for index in 0...(allPhotos.count - 1) {
            let asset = allPhotos.object(at:  index)
            let photo = Photo()
            photo.identifier = asset.localIdentifier
            print("handleAllPhotos for \(index)")
            resValues.append(photo)
        }
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(resValues)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            self.result(json)
            print("handleAllPhotos 3")
            print("Json \(json ?? "")")
        } catch {
            print("handleAllPhotos 4")
            print("The file could not be loaded")
            self.result("")
        }
    }
    
   // MARK: Handle thumbnail
    func handleThumbnail(arguments:Dictionary<String, AnyObject>){
        let jsonString = arguments["photo"] as! String
        let jsonData = jsonString.data(using: .utf8)!
        let photo = try! JSONDecoder().decode(Photo.self, from: jsonData)
        let size = arguments["size"] as! Int
        let quality = arguments["quality"] as! Int
        let times = arguments["times"] as! Int
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.resizeMode = PHImageRequestOptionsResizeMode.exact
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.version = .current
        
        let assets: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [photo.identifier!], options: nil)
        
        if (assets.count > 0) {
            let asset: PHAsset = assets[0];
            
            let ID: PHImageRequestID = manager.requestImage(
                for: asset,
                targetSize: CGSize(width: size, height: size),
                contentMode: PHImageContentMode.aspectFill,
                options: options,
                resultHandler: {
                    (image: UIImage?, info) in
                    //                              let controller = self.window.rootViewController as! FlutterViewController
                    self.binaryMessenger.send(onChannel: SwiftUtilsPlugin.CHANNEL + photo.identifier! + String(times), message: image?.jpegData(compressionQuality: CGFloat(quality / 100)))
                    
            })
            
            if(PHInvalidImageRequestID != ID) {
                self.result(true);
                return
            }
        }
        self.result(false)
    }
    
    // MARK: Handle check permission
    func handleCheckPermission(args:[String]){
        var result:[Int] = [];
        for item in args {
            if item == IOS_PHOTO_LIBRARY{
                let value = permission.checkPhotoLibraryPermission()
                result.append(value);
            }else if item == IOS_CAMERA{
                let value = permission.checkCameraPermission()
                result.append(value);
            }
        }
        self.result(result)
    }
    
   // MARK: Handle request permission
    func handleRequestPermission(args:[String]){
        var statusArray:[String:Bool] = [:]
        var resultArray:[String:Int] = [:]
        for item in args{
            statusArray[item] = false
            resultArray[item] = -1;
        }
        
        for item in args{
            if item == IOS_PHOTO_LIBRARY{
                permission.requestPhotoLibraryPermission(completion: { value in
                    statusArray[self.IOS_PHOTO_LIBRARY] = true
                    resultArray[self.IOS_PHOTO_LIBRARY] = value
                    self.handleDoneRequestPermission(statusArray:statusArray, resultArray:resultArray)
                })
            }else if item == IOS_CAMERA{
                permission.requestCameraPermission(completion: { value in
                    statusArray[self.IOS_CAMERA] = true
                    resultArray[self.IOS_CAMERA] = value
                    self.handleDoneRequestPermission(statusArray:statusArray, resultArray:resultArray)
                })
            }
        }
    }
    
    // MARK: Handle done request permission
    func handleDoneRequestPermission( statusArray:[String:Bool],
                                      resultArray:[String:Int]){
        for (_, value) in statusArray {
            if !value{
                return
            }
        }
        
        var result:[Int] = [];
        for (_, value) in resultArray {
            result.append(value);
        }
        
        self.result(result)
    }
    
    // MARK: Open app setting
    func handleOpenAppSetting(){
        guard let url = URL(string:UIApplication.openSettingsURLString) else{
            return
        }
        
        if !UIApplication.shared.canOpenURL(url){
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: download image from url
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // MARK: protocol stub for download completion tracking
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationFileUrl)
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
        }
        print("Finish download \(location)");
        let rawUrl = destinationFileUrl.absoluteString
        let urlString =  NSString(string: rawUrl).removingPercentEncoding!
        
        
        let index = urlString.index(urlString.endIndex, offsetBy: -(urlString.count - 7))
        let subString = urlString[index...]
        
        let data =  "OK \(subString)".data(using: .utf8)
        self.binaryMessenger.send(onChannel: SwiftUtilsPlugin.CHANNEL + "download", message:data)
    }
    
    
    // MARK: protocol stubs for tracking download progress
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            print("\(self.fileSize) - \(bytesWritten) - \(totalBytesWritten) - \(totalBytesExpectedToWrite)");
            print("\(totalBytesWritten * 100/self.fileSize)%");
            let percent = (totalBytesWritten * 100/self.fileSize)
            
            let data =  String(percent).data(using: .utf8)
            
            self.binaryMessenger.send(onChannel: SwiftUtilsPlugin.CHANNEL + "download", message:data)
        }
    }
}

