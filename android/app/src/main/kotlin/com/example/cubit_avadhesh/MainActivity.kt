// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.example.cubit_avadhesh


import android.R.attr.bitmap
import android.content.*
import android.content.pm.PackageManager
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.ContactsContract
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.nio.ByteBuffer


class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "samples.flutter.io/battery"
    private val CHARGING_CHANNEL = "samples.flutter.io/charging"
    private val CONTACT_CHANNEL = "samples.flutter.io/contact"
    private val TAG = "PermissionDemo"
    private var resolver: ContentResolver? = null


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
        contactChannel();
    }

    private fun contactChannel() {
        MethodChannel(
            flutterEngine!!.dartExecutor,
            CONTACT_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getContact") {
                val batteryLevel = getContactNumbers();
                if (batteryLevel.isNotEmpty()) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Contact not available.", null)
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

    private fun getContactNumbers(): ArrayList<HashMap<Any, Any>> {
        val contactsNumberMap = ArrayList<HashMap<Any, Any>>()


        val phoneCursor: Cursor? = context.contentResolver.query(
            ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
            null,
            null,
            null,
            null
        )
        if (phoneCursor != null && phoneCursor.count > 0) {
            val numberIndex =
                phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)
            val nameIndex =
                phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)
            val contactIndex =
                phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID)
            val photoIndex =
                phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI)

            while (phoneCursor.moveToNext()) {
                val number: String = phoneCursor.getString(numberIndex)
                val name: String = phoneCursor.getString(nameIndex)
                val contactID: Long = phoneCursor.getLong(contactIndex)

                val hashMap: HashMap<Any, Any> = HashMap()
                hashMap["name"] = name
                hashMap["phones"] = number
                var photo: Bitmap? = null
                try {

                       if(phoneCursor.getString(photoIndex)!=null) {
                           val inputStream = ContactsContract.Contacts.openContactPhotoInputStream(
                               contentResolver,
                               ContentUris.withAppendedId(
                                   ContactsContract.Contacts.CONTENT_URI,
                                   contactID
                               )
                           )
                           if (inputStream != null) {
                               photo = BitmapFactory.decodeStream(inputStream)
                               val outputStream = ByteArrayOutputStream()
                               photo.compress(Bitmap.CompressFormat.JPEG, 80, outputStream)
                               val byteArray = outputStream.toByteArray()
                           }
                           assert(inputStream != null)
                           inputStream!!.close()
                       }else {
                           val outputStream = ByteArrayOutputStream()
                           val byteArray = outputStream.toByteArray()
                           hashMap["photo"] = byteArray
                       }


                } catch (e: IOException) {
                    e.printStackTrace()
                }

                if (!contactsNumberMap.contains(hashMap)) {
                    contactsNumberMap.add(hashMap);
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

    //Retrieve photo (this method gets a large photo, for thumbnail follow the link below)

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>, grantResults: IntArray
    ) {
        when (requestCode) {
            200 -> {

                if (grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED) {

                    Log.d(TAG, "Permission has been denied by user")
                } else {
                    contactChannel()
                }
            }
        }
    }

}