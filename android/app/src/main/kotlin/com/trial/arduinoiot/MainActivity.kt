package com.trial.arduinoiot

import android.content.res.AssetFileDescriptor
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel

class MainActivity : FlutterActivity() {

    var linearTflite: Interpreter? = null
    var dnnTflite: Interpreter? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        try {
            dnnTflite = Interpreter(loadDnnModelFile())
            linearTflite = Interpreter(loadLinearModelFile())
        } catch (ex: Exception) {
            ex.printStackTrace()
        }

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "com.trial.arduinoiot")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "linearPredict" -> {
                        val prediction = doLinearInference(call.arguments as List<Float>)


                        result.success(prediction)
                    }
                    "dnnPredict" -> {
                        val prediction = doDnnInference(call.arguments as List<Float>)

                        result.success(prediction)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun loadLinearModelFile(): MappedByteBuffer {
        val fileDescriptor: AssetFileDescriptor = this.assets.openFd("dnn_model.tflite")
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel: FileChannel = inputStream.channel
        val startOffset: Long = fileDescriptor.startOffset
        val declareLength: Long = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declareLength)
    }

    private fun loadDnnModelFile(): MappedByteBuffer {
        val fileDescriptor: AssetFileDescriptor = this.assets.openFd("dnn_model.tflite")
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel: FileChannel = inputStream.channel
        val startOffset: Long = fileDescriptor.startOffset
        val declareLength: Long = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declareLength)
    }

    private fun doDnnInference(list: List<Float>): Float {
//        val inputVal = FloatArray(3)
//        inputVal[0] = 0.003863636F
//        inputVal[1] = 92.11363636F
//        inputVal[2] = 21.39022727F
        val output = Array(1) { FloatArray(1) }
        dnnTflite!!.run(list.toFloatArray(), output)
        println(output[0][0])
        return output[0][0]
    }

    private fun doLinearInference(list: List<Float>): Float {
//        val inputVal = FloatArray(3)
//        inputVal[0] = 0.003863636F
//        inputVal[1] = 92.11363636F
//        inputVal[2] = 21.39022727F
        val output = Array(1) { FloatArray(1) }
        linearTflite!!.run(list.toFloatArray(), output)
        println(output[0][0])
        return output[0][0]
    }
}
