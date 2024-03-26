package com.exnodes.flutter_nuvei_sdk.plugins.platform.PlatformView.PlatformViewFactory

import android.content.Context
import com.exnodes.flutter_nuvei_sdk.plugins.platform.PlatformView.NativeView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return NativeView(context)
    }
}
