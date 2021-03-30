package com.nvn.utils.storage

import android.content.ContentResolver
import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.webkit.MimeTypeMap
import com.nvn.utils.model.Photo
import io.flutter.plugin.common.BinaryMessenger
import java.io.*


object StorageUtil {
    private const val TAG = "StorageUtil"
    private const val BUFFER_SIZE = 1024 * 1024 * 8
    private const val DEGREES_90 = 90
    private const val DEGREES_180 = 180
    private const val DEGREES_270 = 270
    private const val SCALE_FACTOR = 50.0

    /**
     * Get all path of images in storage.
     */
    fun getAllPhotos(context: Context): MutableList<Photo> {
        val listOfAllImages = mutableListOf<Photo>()
        val orderBy = MediaStore.Images.Media._ID + " DESC"
        val projection = arrayOf(
                MediaStore.Images.Media.DATA,
                MediaStore.Images.Media._ID)

        val cursor: Cursor = context.contentResolver.query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI, projection,
                null, null, orderBy) ?: return listOfAllImages
        while (cursor.moveToNext()) {
            val imgId = cursor.getInt(cursor.getColumnIndex(MediaStore.MediaColumns._ID))
            val identifier = Uri.withAppendedPath(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "" + imgId)
            val photo = Photo(identifier.toString())
            val path = cursor.getString(cursor.getColumnIndex(MediaStore.MediaColumns.DATA))
            Log.e("getAllPhotos identifier", photo.identifier)
            Log.e("getAllPhotos path", path)
            listOfAllImages.add(photo)
        }
        cursor.close()

        return listOfAllImages
    }

    /**
     * Get all path of images in storage.
     */
    fun getPath(context: Context, identifier: String): String? {
        var result: String? = null

        var cursor: Cursor? = null
        try {
            val uri = Uri.parse(identifier)
            val proj = arrayOf(MediaStore.Images.Media.DATA)
            cursor = context.contentResolver.query(uri, proj, null, null, null)
            if (cursor == null) {
                return null
            }
            val index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            if (cursor.moveToFirst()) {
                val path = cursor.getString(index)
                result = path
            }
        } finally {
            cursor?.close()
        }
        return result
    }


    /**
     * Share photo to picture.
     */
    fun sharePhoto(
            context: Context,
            path: String
    ): Photo? {

        val file = File(path)
        val extension = MimeTypeMap.getFileExtensionFromUrl(file.toString())
        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
        var source = getBytesFromFile(file)

        val rotatedBytes = getRotatedBytesIfNecessary(source, path)

        if (rotatedBytes != null) {
            source = rotatedBytes
        }

        val baseFolderName = Environment.DIRECTORY_PICTURES
        val dirPath = createDirIfNotExist(
                Environment.getExternalStoragePublicDirectory(baseFolderName).path) ?: return null
        val imageFilePath = File(dirPath, file.name).absolutePath

        val values = ContentValues()
        values.put(MediaStore.Images.ImageColumns.DATA, imageFilePath)
        values.put(MediaStore.Images.Media.TITLE, file.name)
        values.put(MediaStore.Images.Media.DISPLAY_NAME, file.name)
        values.put(MediaStore.Images.Media.MIME_TYPE, mimeType)
        values.put(MediaStore.Images.Media.DATE_ADDED, System.currentTimeMillis())
        values.put(MediaStore.Images.Media.DATE_TAKEN, System.currentTimeMillis())

        var imageUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI

        imageUri = context.contentResolver.insert(imageUri, values)
        if (source == null) {
            if (imageUri != null) {
                context.contentResolver.delete(imageUri, null, null)
            }
            return null
        }

        var outputStream: OutputStream? = null
        if (imageUri != null) {
            outputStream = context.contentResolver.openOutputStream(imageUri)
        }

        outputStream?.use {
            outputStream.write(source)
        }

        val pathId = ContentUris.parseId(imageUri)
        val miniThumb = MediaStore.Images.Thumbnails.getThumbnail(
                context.contentResolver, pathId, MediaStore.Images.Thumbnails.MINI_KIND, null
        )
        storeThumbnail(context.contentResolver, miniThumb, pathId)

        return Photo(imageUri.toString(), imageFilePath)
    }

    /**
     *   Download file
      */

    fun downloadFile(context:Context, messenger: BinaryMessenger?, url:String, fileName:String, fileSize:Int){
      val appName = getAppName(context)
       val dir = File(Environment.getExternalStorageDirectory(), appName)
        val dirPath = createDirIfNotExist(
                dir.absolutePath) ?: return
        val file = File(dir, fileName)
        DownloadFile(messenger, url, file.absolutePath, fileName, fileSize).execute()
    }

    /**
     *   Get app name
     */

    private fun getAppName(context:Context):String{
        val packageManager: PackageManager = context.packageManager
        var applicationInfo: ApplicationInfo? = null
        try {
            applicationInfo = packageManager.getApplicationInfo(context.applicationInfo.packageName, 0)
        } catch (e: PackageManager.NameNotFoundException) {
        }
        return (if (applicationInfo != null) packageManager.getApplicationLabel(applicationInfo).toString() else "Unknown")
    }

//    /**
//     * Copy share document .
//     */
//    fun copyShareDocument(
//            context: Context,
//            path: String
//    ): String? {
//
//        val file = File(path)
//        val extension = MimeTypeMap.getFileExtensionFromUrl(file.toString())
//        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
//
//        val baseFolderName = Environment.DIRECTORY_DOCUMENTS
//        val dirPath = createDirIfNotExist(
//                Environment.getExternalStoragePublicDirectory(baseFolderName).path) ?: return null
//        val target = File(dirPath, file.name).absolutePath
//
//        val input: InputStream = FileInputStream(path)
//        val out: OutputStream = FileOutputStream(target)
//
//        val buf = ByteArray(1024)
//        var len: Int
//        while (input.read(buf).also { len = it } > 0) {
//            out.write(buf, 0, len)
//        }
//        input.close()
//        out.close()
//        scanMedia(context, target, mimeType)
//        return target
//    }

//    /**
//     * Copy share document .
//     */
//    fun copySharePhoto(
//            context: Context,
//            path: String
//    ): String? {
//
//        val file = File(path)
//        val extension = MimeTypeMap.getFileExtensionFromUrl(file.toString())
//        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
//
//        val baseFolderName = Environment.DIRECTORY_PICTURES
//        val dirPath = createDirIfNotExist(
//                Environment.getExternalStoragePublicDirectory(baseFolderName).path) ?: return null
//        val target = File(dirPath, file.name).absolutePath
//
//        val input: InputStream = FileInputStream(path)
//        val out: OutputStream = FileOutputStream(target)
//
//        val buf = ByteArray(1024)
//        var len: Int
//        while (input.read(buf).also { len = it } > 0) {
//            out.write(buf, 0, len)
//        }
//        input.close()
//        out.close()
//        scanMedia(context, target, mimeType)
//        return target
//    }

    /**
     *     Scan media file
     */

    private fun scanMedia(context: Context,
                          target: String, mimeType: String?) {
        MediaScannerConnection.scanFile(
                context, arrayOf<String>(target), arrayOf(mimeType, "*/*"),
                object : MediaScannerConnection.MediaScannerConnectionClient {
                    override fun onMediaScannerConnected() {
                    }

                    override fun onScanCompleted(path: String?, uri: Uri?) {
                    }
                })

    }

    private fun getBytesFromFile(file: File): ByteArray? {
        val size = file.length().toInt()
        val bytes = ByteArray(size)
        val buf = BufferedInputStream(FileInputStream(file))
        buf.use {
            buf.read(bytes, 0, bytes.size)
        }
        return bytes
    }

    /**
     * @param contentResolver - content resolver
     * @param source          - bitmap source image
     * @param id              - path id
     */
    private fun storeThumbnail(
            contentResolver: ContentResolver,
            source: Bitmap,
            id: Long
    ) {

        val matrix = Matrix()

        val scaleX = SCALE_FACTOR.toFloat() / source.width
        val scaleY = SCALE_FACTOR.toFloat() / source.height

        matrix.setScale(scaleX, scaleY)

        val thumb = Bitmap.createBitmap(
                source, 0, 0,
                source.width,
                source.height, matrix,
                true
        )

        val values = ContentValues()
        values.put(MediaStore.Images.Thumbnails.KIND, MediaStore.Images.Thumbnails.MICRO_KIND)
        values.put(MediaStore.Images.Thumbnails.IMAGE_ID, id.toInt())
        values.put(MediaStore.Images.Thumbnails.HEIGHT, thumb.height)
        values.put(MediaStore.Images.Thumbnails.WIDTH, thumb.width)

        val thumbUri = contentResolver.insert(
                MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI, values
        )

        var outputStream: OutputStream? = null
        outputStream.use {
            if (thumbUri != null) {
                outputStream = contentResolver.openOutputStream(thumbUri)
            }
        }
    }

    /**
     * @param orientation - exif orientation
     * @return how many degrees is file rotated
     */
    private fun exifToDegrees(orientation: Int): Int {
        return when (orientation) {
            ExifInterface.ORIENTATION_ROTATE_90 -> DEGREES_90
            ExifInterface.ORIENTATION_ROTATE_180 -> DEGREES_180
            ExifInterface.ORIENTATION_ROTATE_270 -> DEGREES_270
            else -> 0
        }
    }

    /**
     * @param path - path to bitmap that needs to be checked for orientation
     * @return exif orientation
     * @throws IOException - can happen while creating [ExifInterface] object for
     * provided path
     */
    @Throws(IOException::class)
    private fun getRotation(path: String): Int {
        val exif = ExifInterface(path)
        return exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_NORMAL
        )
    }


    /**
     * @param source -  array of bytes that will be rotated if it needs to be done
     * @param path   - path to image that needs to be checked for rotation
     * @return - array of bytes from rotated image, if rotation needs to be performed
     */
    private fun getRotatedBytesIfNecessary(source: ByteArray?, path: String): ByteArray? {
        var rotationInDegrees = 0

        try {
            rotationInDegrees = exifToDegrees(getRotation(path))
        } catch (e: IOException) {
            Log.d(TAG, e.toString())
        }

        if (rotationInDegrees == 0) {
            return null
        }

        val bitmap = BitmapFactory.decodeByteArray(source, 0, source!!.size)
        val matrix = Matrix()
        matrix.preRotate(rotationInDegrees.toFloat())
        val adjustedBitmap = Bitmap.createBitmap(
                bitmap, 0, 0,
                bitmap.width, bitmap.height, matrix, true
        )
        bitmap.recycle()

        val rotatedBytes = bitmapToArray(adjustedBitmap)

        adjustedBitmap.recycle()

        return rotatedBytes
    }

    private fun bitmapToArray(bmp: Bitmap): ByteArray {
        val stream = ByteArrayOutputStream()
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, stream)
        val byteArray = stream.toByteArray()
        bmp.recycle()
        return byteArray
    }

    private fun createDirIfNotExist(dirPath: String): String? {
        val dir = File(dirPath)
        return if (!dir.exists()) {
            if (dir.mkdirs()) {
                dir.path
            } else {
                null
            }
        } else {
            dir.path
        }
    }
}

