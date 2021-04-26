package com.evilratt.flutter_zoom_sdk;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterZoomPlugin */
public class FlutterZoomSdkPlugin {

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    registrar.platformViewRegistry().registerViewFactory("flutter_zoom_sdk", new ZoomViewFactory(registrar.messenger()));
  }
}
