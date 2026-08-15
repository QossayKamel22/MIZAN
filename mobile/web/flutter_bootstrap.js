{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    // Serve CanvasKit from the bundled build output instead of the
    // gstatic.com CDN — avoids a blank/grey screen in sandboxed or
    // restricted-network environments where that CDN isn't reachable
    // from the browser.
    canvasKitBaseUrl: "canvaskit/",
  },
});
