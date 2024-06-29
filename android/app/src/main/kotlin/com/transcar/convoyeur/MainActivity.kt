package com.transcar.convoyeur


import android.os.Bundle
import android.util.Log
import com.telpo.tps550.api.TelpoException
import com.telpo.tps550.api.nfc.Nfc
import com.telpo.tps550.api.util.StringUtil
import java.util.Locale
import android.annotation.SuppressLint

import android.content.DialogInterface

import android.os.Handler

import android.os.Message


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {


    private var activateThread: Thread? = null
    private var handler: Handler? = null
    private var isChecking = false
    private val CHECK_NFC_TIMEOUT = 1
    private val SHOW_NFC_DATA = 2
    private val B_CPU: Byte = 3
    private val A_CPU: Byte = 1
    private val A_M1: Byte = 2
    private val TAG = "telpo_mifare_classic"
    private var eventChannel = "platform_channel_events/nfcsession"
    private var nfc: Nfc? = null
    private val DEFAULT_PASSWD = byteArrayOf(
        0xff.toByte(),
        0xff.toByte(),
        0xff.toByte(),
        0xff.toByte(),
        0xff.toByte(),
        0xff.toByte()
    )
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setMethodCallHandler { call, result ->
            if (call.method == "sendData") {
                val message = call.argument<String>("message")
                if (message != null) {
                    // Handle the message received from Flutter
                    receivedMessage(message)
                    result.success("Data received on Android side")
                } else {
                    result.error("ERROR", "Message is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
    fun sendData(){}
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //enableEdgeToEdge()
        initView()


        nfc = Nfc(this)
        try {
            //nfc!!.open()
            //closeActivateMifareClassicFunction()
            //activateThread = ActivateThread()
            //activateThread!!.start()
            activateTrhead56()

        } catch (e: TelpoException) {
            //Log.d("Open NFC", e.message!!)
        }
    }
    private inner class ActivateThread() : Thread() {
        var nfcData: ByteArray? = null
        override fun run() {
            isChecking = true;
            
            while (isChecking) {
                try {
                    nfcData = nfc!!.activate(1000)
                    // 1000ms
                    if (null != nfcData) {
                        
                       handler!!.sendMessage(handler!!.obtainMessage(SHOW_NFC_DATA, nfcData))
                        isChecking = false;
                        nfc!!.close()
                        break;
                    } else {
                        //sleep(3000)
                        Log.d(TAG, "Check the mifare classic card timeout...")
                        //handler!!.sendMessage(handler!!.obtainMessage(CHECK_NFC_TIMEOUT, null))
                    }
                } catch (e: TelpoException) {
                 //   e.printStackTrace()
                  //  sleep(10000)
                }
            }
        }
    }
      @SuppressLint("HandlerLeak")
    private fun initView() {
       // openBtn = findViewById<Button>(R.id.openBtn)
       // closeBtn = findViewById<Button>(R.id.closeBtn)
       // checkBtn = findViewById<Button>(R.id.checkBtn)
       // readBlockBtn = findViewById<Button>(R.id.readBlockBtn)
       // writeBlockBtn = findViewById<Button>(R.id.writeBlockBtn)
       // readMultiSectorBtn = findViewById<Button>(R.id.readMultiSectorBtn)
       // getCardInfoTextView = findViewById<TextView>(R.id.getCardInfoTextView)
       // readBlockInfoTextView = findViewById<TextView>(R.id.readBlockInfoTextView)
       // readMultiSectorTextView = findViewById<TextView>(R.id.readMultiSectorTextView)

        //closeNFC();
        handler = object : Handler() {
            @SuppressLint("SetTextI18n")
            override fun handleMessage(msg: Message) {
                when (msg.what) {
                    CHECK_NFC_TIMEOUT -> {}
                    SHOW_NFC_DATA -> {

                        val uid_data = msg.obj as ByteArray
                        Log.d("tagg", "nfcdata[" + StringUtil.toHexString(uid_data) + "]")
                        if (uid_data[0].toInt() == 0x42) {
                            //
                            val atqb = ByteArray(uid_data[16].toInt())
                            val pupi = ByteArray(4)
                            var type: String? = null
                            System.arraycopy(uid_data, 17, atqb, 0, uid_data[16].toInt())
                            System.arraycopy(uid_data, 29, pupi, 0, 4)
                            if (uid_data[1] == B_CPU) {
                                type = "CPU"
                            } else {
                                type = "unknow"
                            }
                            //closeActivateMifareClassicFunction()
                            /*getCardInfoTextView!!.setText(
                                "Card Type: Type B " + type +
                                        "\r\n" + "ATQB: " + StringUtil.toHexString(atqb) +
                                        "\r\n" + "PUPI: " + StringUtil.toHexString(pupi)
                            )*/
                            Log.d("tagg", "Felica uid_data:" + StringUtil.toHexString(uid_data))
                            sendNfcDataToFlutter(StringUtil.toHexString(uid_data));
                        } else if (uid_data[0].toInt() == 0x41) {
                            val atqa = ByteArray(2)
                            val sak = ByteArray(1)
                            val uid = ByteArray(uid_data[5].toInt())
                            var type: String? = null
                            System.arraycopy(uid_data, 2, atqa, 0, 2) //[1]~[2]
                            System.arraycopy(uid_data, 4, sak, 0, 1) //[3]
                            System.arraycopy(uid_data, 6, uid, 0, uid_data[5].toInt())
                            if (uid_data[1] == A_CPU) {
                                type = "CPU"
                                //closeActivateMifareClassicFunction()
                            } else if (uid_data[1] == A_M1) {
                                type = "M1"
                                //Toast.makeText(MainActivity.this, "Don't move your card", Toast.LENGTH_LONG).show();
                               // openActivateMifareClassicFunction()
                            } else {
                                type = "unknow"
                                //closeActivateMifareClassicFunction()
                            }
                            /*getCardInfoTextView!!.setText(
                                ("Card Type: Type A " + type +
                                        "\r\n" + "ATQA: " + StringUtil.toHexString(atqa) +
                                        "\r\n" + "SAK: " + StringUtil.toHexString(sak) +
                                        "\r\n" + "UID: " + StringUtil.toHexString(uid))
                            )*/
                            Log.d("tagg", "uid_data:" + StringUtil.toHexString(uid))
                           sendNfcDataToFlutter(StringUtil.toHexString(uid))
                        } else if (uid_data[0].toInt() == 0x46) {
                            // F卡
                            //Log.d("tagg", "uid_data1:" + StringUtil.toHexString(uid))
                            val idm = ByteArray(8)
                            val pmm = ByteArray(8)
                            System.arraycopy(uid_data, 33, idm, 0, 8)
                            System.arraycopy(uid_data, 41, pmm, 0, 8)
                            Log.d("tagg", "Felica idm:" + StringUtil.toHexString(idm))
                            Log.d("tagg", "Felica pmm:" + StringUtil.toHexString(pmm))
                            val type = "Felica card"
                            /*getCardInfoTextView!!.setText(
                                ("Card Type: Type C " + type +
                                        "\r\n" + "idm:" + StringUtil.toHexString(idm) +
                                        "\r\n" + "pmm:" + StringUtil.toHexString(pmm))
                            )*/
                            activateTrhead56()
                        } else {
                            Log.e(TAG, "unknow type card!!")
                            activateTrhead56()
                        }
                        //activateThread = ActivateThread()
                        //activateThread!!.start()
                    }

                    else -> {}
                }
                //checkBtn.setEnabled(true);
            }
        }
    }
    private fun receivedMessage(message: String){
        Log.d(TAG, "Reactivate NFC thread")
        activateTrhead56();
    }
    private fun activateTrhead56(){
        nfc!!.open()
        activateThread = ActivateThread()
        activateThread!!.start()
    }
    private fun sendNfcDataToFlutter(nfcData: String) {

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, eventChannel).invokeMethod("onNfcData", nfcData)


        }


        
    }

    
}
