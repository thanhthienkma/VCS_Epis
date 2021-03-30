package com.nvn.utils.storage

import android.os.AsyncTask
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import java.io.BufferedInputStream
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.net.URL
import java.net.URLConnection
import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets

class DownloadFile(
        var messenger: BinaryMessenger?,
        var urlString:String, var dest:String, var fileName:String, var fileSie:Int): AsyncTask<String, String, String>() {
    override fun doInBackground(vararg params: String?): String {
        var count: Int
        try {
            val url = URL(urlString)
            val connection: URLConnection = url.openConnection()
            connection.connect()

            // download the file
            val input: InputStream = BufferedInputStream(url.openStream(),
                    8192)

            // Output stream
            val output: OutputStream = FileOutputStream(dest)
            val data = ByteArray(1024)
            var total: Long = 0
            while (input.read(data).also { count = it } != -1) {
                total += count.toLong()
                // publishing the progress....
                // After this onProgressUpdate will be called
                publishProgress("" + (total * 100 / fileSie).toInt())

                // writing data to file
                output.write(data, 0, count)
            }
            // flushing output
            output.flush()

            // closing streams
            output.close()
            input.close()
        } catch (e: Exception) {
            Log.e("Error: ", e.message)
        }
        return ""
    }

    override fun onProgressUpdate(vararg values: String?) {
        super.onProgressUpdate(*values)
        if(values == null || values.isEmpty()){
            return
        }
        val dataString = values[0]!!

        val bytes: ByteArray = dataString.toByteArray(StandardCharsets.UTF_8)
        val buffer = ByteBuffer.wrap(bytes)
        this.messenger?.send("utilsdownload", buffer)
    }

    override fun onPostExecute(result: String?) {
        super.onPostExecute(result)
        val dataString = "OK "
        val bytes: ByteArray = dataString.toByteArray(StandardCharsets.UTF_8)
        val buffer = ByteBuffer.wrap(bytes)
        this.messenger?.send("utilsdownload", buffer)
    }
}