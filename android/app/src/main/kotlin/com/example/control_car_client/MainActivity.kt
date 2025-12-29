package uz.redeem.client

import android.os.Bundle
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        MapKitFactory.setApiKey("480938af-41ea-45ce-925b-4b629f9739a3")
        super.onCreate(savedInstanceState)
    }
}