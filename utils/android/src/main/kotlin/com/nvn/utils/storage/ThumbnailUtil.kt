package com.nvn.utils.storage

import android.app.Activity
import android.content.Context
import android.database.CursorIndexOutOfBoundsException
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.AsyncTask
import android.provider.MediaStore
import android.util.Log
import com.nvn.utils.model.Photo
import io.flutter.plugin.common.BinaryMessenger
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.net.MalformedURLException
import java.nio.ByteBuffer

class ThumbnailUtil(private var channel:String, private var activity: Activity,
                    private var messenger: BinaryMessenger?,
                    private var photo: Photo,
                    private  var size: Int,
                    private var quality: Int,
                    private var times:Int
) : AsyncTask<String, Void, ByteBuffer?>() {

    override fun doInBackground(vararg p0: String?): ByteBuffer? {
        Log.e("TAG ThumbnailUtil","doInBackground");
        val uri = Uri.parse(photo.identifier)
        var byteArray: ByteArray? = null

        try {
            // get a reference to the activity if it is still there
            if (activity == null || activity!!.isFinishing){
                return null
            }

            val sourceBitmap = getCorrectlyOrientedImage(activity!!, uri)
            val bitmap = ThumbnailUtils.extractThumbnail(sourceBitmap, this.size, this.size, ThumbnailUtils.OPTIONS_RECYCLE_INPUT)
                    ?: return null

            val bitmapStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, this.quality, bitmapStream)
            byteArray = bitmapStream.toByteArray()
            bitmap.recycle()
            bitmapStream.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        
        val buffer: ByteBuffer
        if (byteArray != null) {
            buffer = ByteBuffer.allocateDirect(byteArray.size)
            buffer.put(byteArray)
            return buffer
        }
        return null
    }

    /**
     * Get correctly oriented image
     */
    @Throws(IOException::class)
    private fun getCorrectlyOrientedImage(context: Context, photoUri: Uri): Bitmap? {
        Log.e("ThumnbailUtil", "getCorrectlyOrientedImage " + photoUri);
        var inputStream = context.contentResolver.openInputStream(photoUri)
        val dbo = BitmapFactory.Options()
        dbo.inScaled = false
        dbo.inSampleSize = 1
        dbo.inJustDecodeBounds = true
        BitmapFactory.decodeStream(inputStream, null, dbo)
        inputStream?.close()

        val orientation = getOrientation(context, photoUri)

        var srcBitmap: Bitmap? = null
        inputStream = context.contentResolver.openInputStream(photoUri)
//        3471
        Log.e("ThumnbailUtil", "getCorrectlyOrientedImage inputStream " + inputStream)
        try {
            srcBitmap = BitmapFactory.decodeStream(inputStream)
            Log.e("ThumnbailUtil", "getCorrectlyOrientedImage srcBitmap " +srcBitmap)
            inputStream?.close()

            if (orientation > 0) {
                val matrix = Matrix()
                matrix.postRotate(orientation.toFloat())

                srcBitmap = Bitmap.createBitmap(srcBitmap, 0, 0, srcBitmap.width,
                        srcBitmap.height, matrix, true)
            }

        } catch (error: MalformedURLException) {
            error.printStackTrace();
        } catch (error:IOException) {
            error.printStackTrace();
        }

        return srcBitmap
    }

    /**
     * Get orientation
     */
    private fun getOrientation(context: Context, photoUri: Uri): Int {
        try {

            context.contentResolver.query(photoUri,
                    arrayOf(MediaStore.Images.ImageColumns.ORIENTATION), null, null, null)?.use { cursor ->

                if (cursor == null || cursor.count != 1) {
                    return -1
                }

                cursor.moveToFirst()
                return cursor.getInt(0)
            }
        } catch (ignored: CursorIndexOutOfBoundsException) {

        }
        return -1
    }

    override fun onPostExecute(buffer: ByteBuffer?) {
        super.onPostExecute(buffer)
        Log.e("TAG ThumbnailUtil","Channel image 2 ");
        if (buffer != null) {
            val value = channel  + this.photo.identifier;
            Log.e("TAG ThumbnailUtil","Channel image 2 " + value);
            this.messenger?.send(channel  + this.photo.identifier + this.times, buffer)
            buffer.clear()
        }else{
            Log.e("TAG ThumbnailUtil","Channel image 2  null");
        }
    }
}