package com.lacour.vincent.wificaresp8266.screen

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.*

import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import com.lacour.vincent.wificaresp8266.connector.CarConnector
import kotlinx.android.synthetic.main.voice_control_activity.*
import com.lacour.vincent.wificaresp8266.R
import android.speech.RecognizerIntent
import android.content.Intent
import android.widget.Toast

import android.app.Activity
import android.os.Handler
import android.os.Looper
import com.lacour.vincent.wificaresp8266.storage.Preferences


class VoiceControl : AppCompatActivity() {

    companion object {
        const val REQUEST_CODE: Int = 20100
        const val MAX_MATCHES = 3
        const val DELAY_STOP: Long = 3000
    }

    private lateinit var carConnector: CarConnector
    private lateinit var preferences: Preferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.voice_control_activity)
        setSupportActionBar(findViewById(R.id.toolbar_voice_control))

        if (supportActionBar != null) {
            with(supportActionBar!!) {
                setDisplayHomeAsUpEnabled(true)
                setDisplayShowHomeEnabled(true)
            }
        }

        carConnector = CarConnector(
            this@VoiceControl,
            findViewById(R.id.data1),
            findViewById(R.id.data2),
            this
        )
        preferences = Preferences(this@VoiceControl)


        val pm = packageManager
        val activities =
            pm.queryIntentActivities(Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH), 0)
        val hasVoiceRecognizer: Boolean = activities.size != 0
        if (hasVoiceRecognizer) {
            action_voice.setOnClickListener { startVoiceRecognitionIntent() }
        } else {
            action_voice.setOnClickListener {
                Toast.makeText(
                    this,
                    getString(R.string.speech_recognizer_not_found),
                    Toast.LENGTH_SHORT
                ).show()
            }
        }

        action_button_1.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_2.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_3.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_4.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_5.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_6.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_7.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_8.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
    }


    private fun startVoiceRecognitionIntent() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(
            RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
        )
        val language: String = preferences.getSpeechRecognitionLanguageValue()
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, language)
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, getString(R.string.voice_recognition_prompt))
        startActivityForResult(intent, REQUEST_CODE)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            if (data !== null) {
                val matches = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
                handleVoiceRecognitionMatches(matches!!)
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }


    private fun handleVoiceRecognitionMatches(matches: List<String>) {
        val forwardKeyword: String = preferences.getKeywordForwardValue()
        val backwardKeyword: String = preferences.getKeywordBackwardValue()
        val rightKeyword: String = preferences.getKeywordRightValue()
        val leftKeyword: String = preferences.getKeywordLeftValue()
        action_voice.isEnabled = false

        when {
            isKeywordRecognized(matches, forwardKeyword) -> {
                carConnector.moveForward()
                arrow_up.setBackgroundResource(R.drawable.arrow_up_pressed)
                stopMovingDelayed()
            }
            isKeywordRecognized(matches, backwardKeyword) -> {
                carConnector.moveBackward()
                arrow_down.setBackgroundResource(R.drawable.arrow_down_pressed)
                stopMovingDelayed()
            }
            isKeywordRecognized(matches, rightKeyword) -> {
                carConnector.turnRight()
                arrow_right.setBackgroundResource(R.drawable.arrow_right_pressed)
                stopMovingDelayed()
            }
            isKeywordRecognized(matches, leftKeyword) -> {
                carConnector.turnLeft()
                arrow_left.setBackgroundResource(R.drawable.arrow_left_pressed)
                stopMovingDelayed()
            }
            else -> {
                Toast.makeText(
                    this,
                    getString(R.string.speech_recognizer_no_matches),
                    Toast.LENGTH_LONG
                ).show()
                action_voice.isEnabled = true
            }
        }
    }


    private fun isKeywordRecognized(matches: List<String>, keyword: String): Boolean {
        if (matches.isEmpty()) return false
        val subEndIndex: Int = if (matches.size > MAX_MATCHES - 1) MAX_MATCHES else matches.size
        val mainMatches: List<String> = matches.subList(0, subEndIndex)
        return mainMatches.any { m -> m.contains(keyword) }
    }

    private fun stopMovingDelayed() {
        Handler(Looper.getMainLooper()).postDelayed(
            {
                carConnector.stopMoving()
                action_voice.isEnabled = true
                arrow_up.setBackgroundResource(R.drawable.arrow_up)
                arrow_down.setBackgroundResource(R.drawable.arrow_down)
                arrow_right.setBackgroundResource(R.drawable.arrow_right)
                arrow_left.setBackgroundResource(R.drawable.arrow_left)
            },
            DELAY_STOP
        )
    }


    private fun onTouchAction(v: View, event: MotionEvent): Boolean {
        val isTouchDown = event.action == MotionEvent.ACTION_DOWN
        val isTouchUp = event.action == MotionEvent.ACTION_UP
        if (isTouchDown) {
            val orangeColor = ContextCompat.getColor(this, R.color.colorOrange)
            when (v.id) {
                R.id.action_button_1 -> {
                    carConnector.actionOne()
                    action_button_1.setTextColor(orangeColor)
                }
                R.id.action_button_2 -> {
                    carConnector.actionTwo()
                    action_button_2.setTextColor(orangeColor)
                }
                R.id.action_button_3 -> {
                    carConnector.actionThree()
                    action_button_3.setTextColor(orangeColor)
                }
                R.id.action_button_4 -> {
                    carConnector.actionFour()
                    action_button_4.setTextColor(orangeColor)
                }
                R.id.action_button_5 -> {
                    carConnector.actionFive()
                    action_button_5.setTextColor(orangeColor)
                }
                R.id.action_button_6 -> {
                    carConnector.actionSix()
                    action_button_6.setTextColor(orangeColor)
                }
                R.id.action_button_7 -> {
                    carConnector.actionSeven()
                    action_button_7.setTextColor(orangeColor)
                }
                R.id.action_button_8 -> {
                    carConnector.actionHeight()
                    action_button_8.setTextColor(orangeColor)
                }
            }
            return true
        }
        if (isTouchUp) {
            val whiteColor = ContextCompat.getColor(this, R.color.colorWhite)
            when (v.id) {
                R.id.action_button_1 -> action_button_1.setTextColor(whiteColor)
                R.id.action_button_2 -> action_button_2.setTextColor(whiteColor)
                R.id.action_button_3 -> action_button_3.setTextColor(whiteColor)
                R.id.action_button_4 -> action_button_4.setTextColor(whiteColor)
                R.id.action_button_5 -> action_button_5.setTextColor(whiteColor)
                R.id.action_button_6 -> action_button_6.setTextColor(whiteColor)
                R.id.action_button_7 -> action_button_7.setTextColor(whiteColor)
                R.id.action_button_8 -> action_button_8.setTextColor(whiteColor)
            }
            return true
        }
        return false
    }


    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            finishActivity()
        }
        return true
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater = menuInflater
        inflater.inflate(R.menu.toolbar_voice_control_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean =
        when (item.itemId) {
            android.R.id.home -> {
                finishActivity()
                true
            }
            R.id.action_information -> {
                showInformationDialog()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }

    private fun finishActivity() {
        finish()
        this@VoiceControl.overridePendingTransition(
            R.anim.anim_slide_in_right,
            R.anim.anim_slide_out_right
        )
    }

    private fun showInformationDialog() {
        val builder = AlertDialog.Builder(ContextThemeWrapper(this, R.style.AlertDialogTheme))
        with(builder) {
            setTitle(getString(R.string.voice_dialog_title))
            setMessage(getString(R.string.voice_dialog_message))
            setPositiveButton(getString(R.string.ok)) { _, _ -> }
            show()
        }
    }

}