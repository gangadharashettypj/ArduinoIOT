package com.lacour.vincent.wificaresp8266.connector

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Handler
import android.util.Log
import android.widget.Button
import android.widget.Toast
import com.lacour.vincent.wificaresp8266.R
import com.lacour.vincent.wificaresp8266.storage.Preferences
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.http.GET
import retrofit2.http.Query


private interface CarApiService {
    @GET("/move")
    fun move(@Query("dir") direction: String): Call<Void>

    @GET("/action")
    fun action(@Query("type") type: String): Call<Void>

    @GET("/data1")
    fun data1(): Call<ResponseBody>

    @GET("/data2")
    fun data2(): Call<ResponseBody>
}

class CarConnector(context: Context, data1: Button, data2: Button, activity: Activity) {

    private val preferences = Preferences(context)
    private var service: CarApiService? = null

    var timerHandler: Handler = Handler()
    private val timerRunnable: Runnable = object : Runnable {
        override fun run() {
            if (service == null) return
            val request = (service as CarApiService).data1()
            request.enqueue(object : Callback<ResponseBody> {
                override fun onResponse(
                    call: Call<ResponseBody>,
                    response: Response<ResponseBody>
                ) {

                    val data = response.body()?.string() ?: ""
                    Log.i("Response11", response.body()?.string() ?: "")
                    if (data == "GAS") {
                        activity.runOnUiThread {
                            data1.setBackgroundColor(Color.RED)
                        }
                    } else {
                        activity.runOnUiThread {
                            data1.setBackgroundColor(Color.WHITE)
                        }
                    }

                }

                override fun onFailure(call: Call<ResponseBody>, t: Throwable) {
                    Log.e("Failure", t.message.toString())
                }
            })
            val request1 = (service as CarApiService).data2()
            request1.enqueue(object : Callback<ResponseBody> {
                override fun onResponse(
                    call: Call<ResponseBody>,
                    response: Response<ResponseBody>
                ) {
                    val data = response.body()?.string() ?: ""
                    Log.i("Response22", data)
                    activity.runOnUiThread {
                        if (data == "FLAME") {
                            data2.setBackgroundColor(Color.RED)
                        } else {
                            data2.setBackgroundColor(Color.WHITE)
                        }
                    }
                }

                override fun onFailure(call: Call<ResponseBody>, t: Throwable) {
                    Log.e("Failure", t.message.toString())
                }
            })
            timerHandler.postDelayed(this, 1000)
        }
    }

    init {
        val url = "http://${preferences.getIpAddress()}:${preferences.getPort()}"
        try {
            val retrofit = Retrofit.Builder().baseUrl(url).build()
            service = retrofit.create(CarApiService::class.java)
        } catch (e: IllegalArgumentException) {
            Toast.makeText(
                context,
                context.getString(R.string.invalid_hostname, url),
                Toast.LENGTH_LONG
            ).show()
        }

        timerHandler.postDelayed(timerRunnable, 0);

    }

    fun moveForward() = sendMoveRequest(preferences.getMoveForwardValue())
    fun moveBackward() = sendMoveRequest(preferences.getMoveBackwardValue())
    fun stopMoving() = sendMoveRequest(preferences.getStopValue())
    fun turnLeft() = sendMoveRequest(preferences.getTurnLeftValue())
    fun turnRight() = sendMoveRequest(preferences.getTurnRightValue())

    fun actionOne() = sendActionRequest(preferences.getActionOneValue())
    fun actionTwo() = sendActionRequest(preferences.getActionTwoValue())
    fun actionThree() = sendActionRequest(preferences.getActionThreeValue())
    fun actionFour() = sendActionRequest(preferences.getActionFourValue())
    fun actionFive() = sendActionRequest(preferences.getActionFiveValue())
    fun actionSix() = sendActionRequest(preferences.getActionSixValue())
    fun actionSeven() = sendActionRequest(preferences.getActionSevenValue())
    fun actionHeight() = sendActionRequest(preferences.getActionHeightValue())


    private fun sendMoveRequest(dir: String) {
        if (service == null) return
        val request = (service as CarApiService).move(dir)
        request.enqueue(object : Callback<Void> {
            override fun onResponse(call: Call<Void>, response: Response<Void>) {
                Log.i("Response", response.code().toString())
            }

            override fun onFailure(call: Call<Void>, t: Throwable) {
                Log.e("Failure", t.message.toString())
            }
        })
    }

    private fun sendActionRequest(type: String) {
        if (service == null) return
        val request = (service as CarApiService).action(type)
        request.enqueue(object : Callback<Void> {
            override fun onResponse(call: Call<Void>, response: Response<Void>) {
                Log.i("Response", response.code().toString())
            }

            override fun onFailure(call: Call<Void>, t: Throwable) {
                Log.e("Failure", t.message.toString())
            }
        })
    }

}
