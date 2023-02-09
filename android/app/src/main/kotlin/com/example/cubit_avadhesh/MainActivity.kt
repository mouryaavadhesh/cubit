// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.example.cubit_avadhesh

import android.Manifest
import android.R
import android.app.AlertDialog
import android.content.*
import android.content.pm.PackageManager
import android.database.Cursor
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.ContactsContract
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "samples.flutter.io/battery"
    private val CHARGING_CHANNEL = "samples.flutter.io/charging"
    private val CONTACT_CHANNEL = "samples.flutter.io/contact"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor, CHARGING_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var chargingStateChangeReceiver: BroadcastReceiver? = null
                override fun onListen(arguments: Any, events: EventSink) {
                    chargingStateChangeReceiver = createChargingStateChangeReceiver(events)
                    registerReceiver(
                        chargingStateChangeReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                }

                override fun onCancel(arguments: Any) {
                    unregisterReceiver(chargingStateChangeReceiver)
                    chargingStateChangeReceiver = null
                }
            }
        )
        MethodChannel(
            flutterEngine.dartExecutor,
            BATTERY_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {

                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor,
            CONTACT_CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "getContact") {
                if (VERSION.SDK_INT >= VERSION_CODES.M) {
                    if (ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.READ_CONTACTS
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        if (ActivityCompat.shouldShowRequestPermissionRationale(
                                this,
                                Manifest.permission.READ_CONTACTS
                            )
                        ) {
                            val builder = AlertDialog.Builder(this)
                            builder.setTitle("Read Contacts permission")
                            builder.setPositiveButton(R.string.ok, null)
                            builder.setMessage("Please enable access to contacts.")
                            builder.setOnDismissListener {
                                requestPermissions(
                                    arrayOf<String>(Manifest.permission.READ_CONTACTS),200
                                )
                            }
                            builder.show()
                        } else {
                            requestPermissions(
                                this, arrayOf<String>(Manifest.permission.READ_CONTACTS),
                                200
                            )
                        }
                    } else {
                        val batteryLevel = getContactNumbers();
                        if (batteryLevel.isNotEmpty()) {
                            result.success(batteryLevel)
                        } else {
                            result.error("UNAVAILABLE", "Contact not available.", null)
                        }
                    }
                } else {
                    val batteryLevel = getContactNumbers();
                    if (batteryLevel.isNotEmpty()) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Contact not available.", null)
                    }
                }


            } else {
                result.notImplemented()
            }
        }
    }

    private fun createChargingStateChangeReceiver(events: EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                    events.error("UNAVAILABLE", "Charging status unavailable", null)
                } else {
                    val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                            status == BatteryManager.BATTERY_STATUS_FULL
                    events.success(if (isCharging) "charging" else "discharging")
                }
            }
        }
    }

    private  fun getContactNumbers(): ArrayList<String> {
        val contactsNumberMap = ArrayList<String>()

        val phoneCursor: Cursor? = context.contentResolver.query(
            ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
            null,
            null,
            null,
            null
        )
        if (phoneCursor != null && phoneCursor.count > 0) {
            val contactIdIndex = phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID)
            val numberIndex = phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)
            while (phoneCursor.moveToNext()) {
                val number: String = phoneCursor.getString(numberIndex)
                //check if the map contains key or not, if not then create a new array list with number
                if (!contactsNumberMap.contains(number)) {
                    contactsNumberMap.add(number);
                }
            }
            //contact contains all the number of a particular contact
            phoneCursor.close()
        }
        return contactsNumberMap
    }
    private fun getBatteryLevel(): Int {
        return if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(
                null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
    }
}