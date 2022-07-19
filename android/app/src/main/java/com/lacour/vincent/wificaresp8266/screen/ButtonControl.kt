package com.lacour.vincent.wificaresp8266.screen

import android.os.Bundle
import android.view.*
import android.widget.SeekBar
import android.widget.SeekBar.OnSeekBarChangeListener
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.lacour.vincent.wificaresp8266.R
import com.lacour.vincent.wificaresp8266.connector.CarConnector
import kotlinx.android.synthetic.main.button_control_activity.*


class ButtonControl : AppCompatActivity() {

    private lateinit var carConnector: CarConnector

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.button_control_activity)
        setSupportActionBar(findViewById(R.id.toolbar_button_control))

        if (supportActionBar != null) {
            with(supportActionBar!!) {
                setDisplayHomeAsUpEnabled(true)
                setDisplayShowHomeEnabled(true)
            }
        }

        carConnector = CarConnector(this@ButtonControl)

        arrow_up.setOnTouchListener { v: View, e: MotionEvent -> onTouchArrow(v, e) }
        arrow_right.setOnTouchListener { v: View, e: MotionEvent -> onTouchArrow(v, e) }
        arrow_down.setOnTouchListener { v: View, e: MotionEvent -> onTouchArrow(v, e) }
        arrow_left.setOnTouchListener { v: View, e: MotionEvent -> onTouchArrow(v, e) }

        action_button_1.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_2.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_3.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_4.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_5.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_6.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_7.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }
        action_button_8.setOnTouchListener { v: View, e: MotionEvent -> onTouchAction(v, e) }

        slider1.setOnSeekBarChangeListener(object : OnSeekBarChangeListener {
            override fun onProgressChanged(
                seekBar: SeekBar, progress: Int,
                fromUser: Boolean
            ) {

            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {

            }

            override fun onStopTrackingTouch(seekBar: SeekBar) {
                carConnector.sendActionServoRequest("S1", seekBar.progress)

            }
        })

        slider2.setOnSeekBarChangeListener(object : OnSeekBarChangeListener {
            override fun onProgressChanged(
                seekBar: SeekBar, progress: Int,
                fromUser: Boolean
            ) {
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {

            }

            override fun onStopTrackingTouch(seekBar: SeekBar) {
                carConnector.sendActionServoRequest("S2", seekBar.progress)

            }
        })

        slider3.setOnSeekBarChangeListener(object : OnSeekBarChangeListener {
            override fun onProgressChanged(
                seekBar: SeekBar, progress: Int,
                fromUser: Boolean
            ) {
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {

            }

            override fun onStopTrackingTouch(seekBar: SeekBar) {
                carConnector.sendActionServoRequest("S3", seekBar.progress)

            }
        })

        slider4.setOnSeekBarChangeListener(object : OnSeekBarChangeListener {
            override fun onProgressChanged(
                seekBar: SeekBar, progress: Int,
                fromUser: Boolean
            ) {
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {

            }

            override fun onStopTrackingTouch(seekBar: SeekBar) {
                carConnector.sendActionServoRequest("S4", seekBar.progress)

            }
        })


    }

    private fun onTouchArrow(v: View, event: MotionEvent): Boolean {
        val isTouchDown = event.action == MotionEvent.ACTION_DOWN
        val isTouchUp = event.action == MotionEvent.ACTION_UP
        if (isTouchDown) {
            when (v.id) {
                R.id.arrow_up -> {
                    carConnector.moveForward()
                    arrow_up.setBackgroundResource(R.drawable.arrow_up_pressed)
                }
                R.id.arrow_down -> {
                    carConnector.moveBackward()
                    arrow_down.setBackgroundResource(R.drawable.arrow_down_pressed)
                }
                R.id.arrow_right -> {
                    carConnector.turnRight()
                    arrow_right.setBackgroundResource(R.drawable.arrow_right_pressed)
                }
                R.id.arrow_left -> {
                    carConnector.turnLeft()
                    arrow_left.setBackgroundResource(R.drawable.arrow_left_pressed)
                }
            }
            return true
        }
        if (isTouchUp) {
            carConnector.stopMoving()
            when (v.id) {
                R.id.arrow_up -> arrow_up.setBackgroundResource(R.drawable.arrow_up)
                R.id.arrow_down -> arrow_down.setBackgroundResource(R.drawable.arrow_down)
                R.id.arrow_right -> arrow_right.setBackgroundResource(R.drawable.arrow_right)
                R.id.arrow_left -> arrow_left.setBackgroundResource(R.drawable.arrow_left)
            }
            return true
        }
        return false
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
                    carConnector.sendActionServoRequest("TOGGLE", 0)
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
        inflater.inflate(R.menu.toolbar_button_control_menu, menu)
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
        this@ButtonControl.overridePendingTransition(
            R.anim.anim_slide_in_right,
            R.anim.anim_slide_out_right
        )
    }

    private fun showInformationDialog() {
        val builder = AlertDialog.Builder(ContextThemeWrapper(this, R.style.AlertDialogTheme))
        with(builder) {
            setTitle(getString(R.string.button_dialog_title))
            setMessage(getString(R.string.button_dialog_message))
            setPositiveButton(getString(R.string.ok)) { _, _ -> }
            show()
        }
    }

}