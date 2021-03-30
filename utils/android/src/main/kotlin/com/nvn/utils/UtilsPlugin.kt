package com.nvn.utils

import android.app.Activity
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.google.gson.Gson
import com.nvn.utils.model.Photo
import com.nvn.utils.preference.Preference
import com.nvn.utils.storage.StorageUtil
import com.nvn.utils.storage.ThumbnailUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener 

public class UtilsPlugin : FlutterPlugin, MethodCallHandler, RequestPermissionsResultListener, ActivityAware {
    
    /**
     * Current activity
     */
    private var mActivity: Activity? = null
    /**
     * Result for returning value to dart.
     */
    private var mResult: Result? = null
    /**
     *  Permissions want to allow.
     */
    private var mPermissions: MutableList<String> = mutableListOf()
    /**
     * Binary messenger
     */
    private var mMessenger:BinaryMessenger? = null
    /**
     * Method channel
     */
    private var mMethodChannel:MethodChannel? = null

    companion object {

        const val REQUEST_PERMISSION_CODE = 100
        const val CHANNEL = "utils"
        const val CHECK_PERMISSION_METHOD = "check_permission_method"
        const val REQUEST_PERMISSION_METHOD = "request_permission_method"
        const val ALL_PHOTOS_METHOD = "all_photos_method"
        const val PHOTO_PATH_METHOD = "photo_path_method"
        const val THUMBNAIL_METHOD = "thumbnail_method"
        const val SHARE_PHOTO_METHOD = "share_photo_method"
        const val DOWNLOAD_FILE_METHOD = "download_file_method"

        const val SAVE_INT_VALUE_METHOD = "save_int_value_method"
        const val GET_INT_VALUE_METHOD = "get_int_value_method"
        const val SAVE_DOUBLE_VALUE_METHOD = "save_double_value_method"
        const val GET_DOUBLE_VALUE_METHOD = "get_double_value_method"
        const val SAVE_BOOL_VALUE_METHOD = "save_bool_value_method"
        const val GET_BOOL_VALUE_METHOD = "get_bool_value_method"
        const val SAVE_STRING_VALUE_METHOD = "save_string_value_method"
        const val GET_STRING_VALUE_METHOD = "get_string_value_method"
        const val REMOVE_VALUE_METHOD = "remove_value_method"

        const val KEY = "key"
        const val VALUE = "value"
        
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL)
            val utils = UtilsPlugin()
            utils.mMessenger = registrar.messenger()
            registrar.addRequestPermissionsResultListener(utils)
            channel.setMethodCallHandler(utils)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, CHANNEL)
        this.mMessenger = flutterPluginBinding.binaryMessenger
        this.mMethodChannel = channel
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        this.mResult = result

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            CHECK_PERMISSION_METHOD -> {
                mPermissions = call.arguments as MutableList<String>
                handleCheckPermissions()
            }
            REQUEST_PERMISSION_METHOD -> {
                mPermissions = call.arguments as MutableList<String>
                handleRequestPermission()
            }
            ALL_PHOTOS_METHOD -> {
                handleAllPhotos()
            }
            PHOTO_PATH_METHOD -> {
                val args = call.arguments as String
                handlePhotoPath(args)
            }
           THUMBNAIL_METHOD -> {
                val args = call.arguments as HashMap<String, String>
                handleThumbnail(args)
            }
             SHARE_PHOTO_METHOD->{
                handleSharePhoto(call.arguments as String)
            }
            DOWNLOAD_FILE_METHOD->{
                val args = call.arguments as HashMap<String, Any>
//                args["file_size"] = fileSize;
//                args["url"] = path;
//                args["file_name"] = name;
                handleDownloadFile(args)
            }
            SAVE_INT_VALUE_METHOD->{
                val args = call.arguments as HashMap<String, Any>
                handleSetIntValue(args)
            }
            GET_INT_VALUE_METHOD->{
                val args = call.arguments as String
                handleGetIntValue(args)
            }
            SAVE_DOUBLE_VALUE_METHOD->{
                val args = call.arguments as HashMap<String, Any>
                handleSetDoubleValue(args)
            }
            GET_DOUBLE_VALUE_METHOD->{
                val args = call.arguments as String
                handleGetDoubleValue(args)
            }
            SAVE_BOOL_VALUE_METHOD->{
                val args = call.arguments as HashMap<String, Any>
                handleSetBooleanValue(args)
            }
            GET_BOOL_VALUE_METHOD->{
                val args = call.arguments as String
                handleGetBooleanValue(args)
            }
            SAVE_STRING_VALUE_METHOD->{
                val args = call.arguments as HashMap<String, Any>
                handleSetStringValue(args)
            }
            GET_STRING_VALUE_METHOD->{
                val args = call.arguments as String
                handleGetStringValue(args)
            }
            REMOVE_VALUE_METHOD->{
                val args = call.arguments as String
                handleRemoveValue(args)
            }
//            VIEW_SELECTED_THUMBNAIL_METHOD ->{
//                val args = call.arguments as HashMap<String, String>
//                handleViewSelectedThumbnail(args)
//            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * Handle share photo
     */
    private fun handleSharePhoto(path:String){
        val photo = this.mActivity?.let { StorageUtil.sharePhoto(it,path) }
        if(photo == null){
            this.mResult?.success("");
            return
        }
        this.mResult?.success(Gson().toJson(photo))

    }
    /**
     * Handle copy share document
     */
    private fun handleDownloadFile( args:HashMap<String, Any>){
        val fileSize = args["file_size"] as Int
        val url = args["url"] as String
        val fileName = args["file_name"] as String
        this.mActivity?.let { StorageUtil.downloadFile(it, mMessenger, url,fileName, fileSize) }
        this.mResult?.success("")
    }

//    /**
//     * Handle copy share photo
//     */
//    private fun handleCopySharePhoto(path:String){
//        val value = this.mActivity?.let { StorageUtil.copySharePhoto(it,path) }
//        if(value == null){
//            this.mResult?.success("");
//            return
//        }
//        this.mResult?.success(value)
//    }
//

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
//
//    /**
//     * Handle view selected thumbnail
//     */
//    private fun handleViewSelectedThumbnail(args:HashMap<String, String>){
//        val stringPhoto = args["photo"] as String
//        val photo = Gson().fromJson<Photo>(stringPhoto, Photo::class.java)
//        val size = args["size"] as Int
//        val quality = args["quality"] as Int
//        getViewSelectedThumbnail(photo, size, quality)
//        this.mResult?.success(true)
//    }
//
//    /**(
//     * Call background thumbnail
//     */
//    private fun getViewSelectedThumbnail(photo: Photo, size: Int, quality: Int) {
//        Log.d("TAG ThumbnailUtil","getThumbnail-----");
//        val task = mActivity?.let { ThumbnailUtil(CHANNEL, it, mMessenger, photo, size, quality) }
//        task?.execute()
//    }

    /**
     * Handle thumbnail
     */
    private fun handleThumbnail(args:HashMap<String, String>){
        val stringPhoto = args["photo"] as String
        val photo = Gson().fromJson<Photo>(stringPhoto, Photo::class.java)
        val size = args["size"] as Int
        val quality = args["quality"] as Int
        val times = args["times"] as Int
        getThumbnail(photo, size, quality, times)
        this.mResult?.success(true)
    }


    /**
     * Check permission.
     */
    private fun handleCheckPermissions() {
        var isOk = true
        mPermissions.map {item->
            val isGranted = mActivity?.let { ActivityCompat.checkSelfPermission(it, item) }
            if (isGranted != PackageManager.PERMISSION_GRANTED) {
                isOk = false
            }
        }
        mResult?.success(isOk)
    }

    /**
     * Request permission
     */
    private fun handleRequestPermission() {
        mActivity?.let {
            ActivityCompat.requestPermissions(
                    it,
                mPermissions.toTypedArray(),
                REQUEST_PERMISSION_CODE
        )
        }
    }
    /**
     * Get all photos
     */
    private fun handleAllPhotos() {
        val value = mActivity?.let { StorageUtil.getAllPhotos(it) }
        mResult?.success(Gson().toJson(value))
    }

    /**
     * Get all photos
     */
    private fun handlePhotoPath(identifier: String) {
        val value = mActivity?.let { StorageUtil.getPath(it, identifier) }
        if(value == null){
            mResult?.success(null)
            return
        }

        val photo = Photo(identifier, value)

        Log.d("handlePhotoPath", photo.path)

        mResult?.success(Gson().toJson(photo))
    }

    /**(
     * Call background thumbnail
     */
    private fun getThumbnail(photo: Photo, size: Int, quality: Int, times:Int) {
        Log.d("TAG ThumbnailUtil","getThumbnail-----");
        val task = mActivity?.let { ThumbnailUtil(CHANNEL, it, mMessenger, photo, size, quality, times) }
        task?.execute()
    }


    /**
     * Result of request permissions
     */
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
        when (requestCode) {
            REQUEST_PERMISSION_CODE -> {
                if (grantResults == null) {
                    mResult?.success(false)
                    return false
                }
                if (grantResults.isNotEmpty()) {
                    var isOk = true
                    if (grantResults.size != mPermissions.size) {
                        isOk = false
                    } else {
                        grantResults.map { grant ->
                            if (grant != PackageManager.PERMISSION_GRANTED) {
                                isOk = false
                                return@map
                            }
                        }
                    }
                    mResult?.success(isOk)
                    return isOk
                }
            }
        }
        return false
    }

    /**
     * Clear activity.
     */
    override fun onDetachedFromActivity() {
        this.mActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.mActivity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    /**
     * Get activity is attached
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.mActivity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.mActivity = null
    }

    /**
     * Handle set int value
     */
    private fun handleSetIntValue(args:HashMap<String, Any>) {
        val key = args[KEY] as String
        val value = args[VALUE] as Int
        Preference.setInt(this.mActivity, key, value)
        this.mResult?.success(true)
    }
    /**
     * Handle get int value
     */
    private fun handleGetIntValue(key:String) {
        val value = Preference.getInt(this.mActivity, key)
        this.mResult?.success(value)
    }
    /**
     * Handle set double value
     */
    private fun handleSetDoubleValue(args:HashMap<String, Any>) {
        val key = args[KEY] as String
        val value = args[VALUE] as Double
        Preference.setDouble(this.mActivity, key, value)
        this.mResult?.success(true)
    }
    /**
     * Handle get double value
     */
    private fun handleGetDoubleValue(key:String) {
        val value = Preference.getDouble(this.mActivity, key)
        this.mResult?.success(value)
    }
    /**
     * Handle set boolean value
     */
    private fun handleSetBooleanValue(args:HashMap<String, Any>) {
        val key = args[KEY] as String
        val value = args[VALUE] as Boolean
        Preference.setBoolean(this.mActivity, key, value)
        this.mResult?.success(true)
    }
    /**
     * Handle get double value
     */
    private fun handleGetBooleanValue(key:String) {
        val value = Preference.getBoolean(this.mActivity, key)
        this.mResult?.success(value)
    }
    /**
     * Handle set string value
     */
    private fun handleSetStringValue(args:HashMap<String, Any>) {
        val key = args[KEY] as String
        val value = args[VALUE] as String
        Preference.setString(this.mActivity, key, value)
        this.mResult?.success(true)
    }
    /**
     * Handle get string value
     */
    private fun handleGetStringValue(key:String) {
        val value = Preference.getString(this.mActivity, key)
        this.mResult?.success(value)
    }

    /**
     * Handle remove value
     */
    private fun handleRemoveValue(key:String) {
        Preference.remove(this.mActivity, key)
        this.mResult?.success(true)
    }
}
