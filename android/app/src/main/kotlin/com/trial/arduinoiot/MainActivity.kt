package com.trial.arduinoiot

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.ByteBuffer
import java.nio.channels.FileChannel

class MainActivity : FlutterActivity() {

    private var tflite: Interpreter? = null

    companion object {
        private const val CHANNEL = "ondeviceML"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "predictData") {
                try {
                    tflite = Interpreter(loadModelFile(call.argument<Any>("model").toString() + ".tflite"))
                } catch (e: Exception) {
                    println("Exception while loading: $e")
                    throw RuntimeException(e)
                }
                val args = call.argument<ArrayList<Double>>("arg")!!
                val prediction: Float = predictData(args)
                if (prediction != 0f) {
                    result.success(prediction)
                } else {
                    result.error("UNAVAILABLE", "prediction  not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // This method interact with our model and makes prediction returning value of
    fun predictData(input_data: java.util.ArrayList<Double>): Float {
        val inputArray = Array(1) { FloatArray(input_data.size) }
        var i = 0
        for (e in input_data) {
            inputArray[0][i] = e.toFloat()
            i++
        }
        val output_data = Array(1) { FloatArray(1) }
        tflite!!.run(inputArray, output_data)
        Log.d("tag", ">> " + output_data[0][0])
        return output_data[0][0]
    }


    private fun loadModelFile(modelName: String): ByteBuffer {
        val fileDescriptor = this.assets.openFd(modelName)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }
}
