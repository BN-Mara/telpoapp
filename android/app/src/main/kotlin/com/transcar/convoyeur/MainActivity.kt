package com.transcar.convoyeur


import android.os.Bundle
import android.util.Log
import com.telpo.tps550.api.TelpoException
import com.telpo.tps550.api.nfc.Nfc
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private var nfc: Nfc? = null
    private var activateThread: Thread? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //enableEdgeToEdge()


        nfc = Nfc(this)
        try {
            nfc!!.open()
            //closeActivateMifareClassicFunction()
            activateThread = ActivateThread()
            activateThread!!.start()

        } catch (e: TelpoException) {
            Log.d("Open NFC", e.message!!)
        }
    }
    private inner class ActivateThread() : Thread() {
        var nfcData: ByteArray? = null
        override fun run() {
            //isChecking = true;
            while (true) {
                try {
                    nfcData = nfc!!.activate(500) // 500ms
                    if (null != nfcData) {
                       // handler!!.sendMessage(handler!!.obtainMessage(SHOW_NFC_DATA, nfcData))
                        //isChecking = false;
                        //break;
                    } else {
                        //Log.d(TAG, "Check the mifare classic card timeout...")
                        //handler!!.sendMessage(handler!!.obtainMessage(CHECK_NFC_TIMEOUT, null))
                    }
                } catch (e: TelpoException) {
                    e.printStackTrace()
                }
            }
        }
    }
}
