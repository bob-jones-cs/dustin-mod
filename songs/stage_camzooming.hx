// Compatibility bridge for per-strum-line camera zoom.
// Zoom logic, beat bumps, and stage XML parsing are now handled by the engine
// (PlayState + Stage). This script only bridges legacy variable names:
//   camZoomMult  -> camHudZoomMult  (HUD zoom multiplier)
//   lerpCamZoom  -> camZooming      (zoom enable/disable toggle)
// camZoomLerpMult and forceDefaultCamZoom resolve directly to PlayState properties.

public var camZoomMult:Float = 1;
static var lerpCamZoom:Bool = true;

function create() {
    lerpCamZoom = true;
    camZoomMult = 1;
    camZoomLerpMult = 1;
    forceDefaultCamZoom = false;
}

function update(elapsed) {
    camZooming = lerpCamZoom;
    camHudZoomMult = camZoomMult;
}