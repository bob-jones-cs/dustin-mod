// (Yeah i could probably code this better but i dont care -lunar)
var defaultZoomTween:FlxTween;
var bfZoomTween:FlxTween;
var dadZoomTween:FlxTween;
var gfZoomTween:FlxTween;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Change Stage Zoom") {
        if (params[4]) {
            var flxease:String = params[7] + (params[7] == "linear" ? "" : params[8]);

            if (params[0]) {
                if (defaultZoomTween != null) defaultZoomTween.cancel();
                defaultZoomTween = FlxTween.num(defaultCamZoom, params[5], ((Conductor.crochet / 4) / 1000) * params[6],
                {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {defaultCamZoom = val;});
            }
            if (params[1]) {
                if (bfZoomTween != null) bfZoomTween.cancel();
                bfZoomTween = FlxTween.num(strumLineZooms[1], params[5], ((Conductor.crochet / 4) / 1000) * params[6],
                {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {strumLineZooms[1] = val;});
            }
            if (params[2]) {
                if (dadZoomTween != null) dadZoomTween.cancel();
                dadZoomTween = FlxTween.num(strumLineZooms[0], params[5], ((Conductor.crochet / 4) / 1000) * params[6],
                {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {strumLineZooms[0] = val;});
            }
            if (params[3]) {
                if (gfZoomTween != null) gfZoomTween.cancel();
                gfZoomTween = FlxTween.num(strumLineZooms[2], params[5], ((Conductor.crochet / 4) / 1000) * params[6],
                {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {strumLineZooms[2] = val;});
            }
        } else {
            if (params[0]) defaultCamZoom = params[5];
            if (params[1]) strumLineZooms[1] = params[5];
            if (params[2]) strumLineZooms[0] = params[5];
            if (params[3]) strumLineZooms[2] = params[5];
        }
    }
}