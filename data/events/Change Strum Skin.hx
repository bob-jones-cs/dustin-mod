//
import funkin.game.NoteReskinHelper;

var daPixelZoom = 6;

// Note animation frame-name prefixes (one per direction: left, down, up, right).
// Override these for skins that use different naming conventions in their atlas XML.
var scrollPrefixes = ["purple0", "blue0", "green0", "red0"];
var holdPrefixes = ["purple hold piece", "blue hold piece", "green hold piece", "red hold piece"];
var holdEndPrefixes = ["pruple end hold", "blue hold end", "green hold end", "red hold end"];

function postCreate() {
    var changeTimes = [];
    var changeSkins = [];
    var changePixels = [];

    for (i => event in PlayState.SONG.events) {
        if (event.name != "Change Strum Skin") continue;

        var skin = event.params[0];
        var pixel = event.params[1];
        graphicCache.cache(Paths.image("game/notes/" + skin));
        if (pixel) graphicCache.cache(Paths.image("game/notes/" + skin + "_ENDs"));

        // Dedup: skip duplicate events at the same timestamp
        if (changeTimes.length > 0 && changeTimes[changeTimes.length - 1] == event.time) continue;

        changeTimes.push(event.time);
        changeSkins.push(skin);
        changePixels.push(pixel);
    }

    // Pre-reskin all notes at load time so gameplay has zero cost
    for (i => time in changeTimes) {
        var skin = changeSkins[i];
        var isPixel = changePixels[i];
        var endTime = changeTimes[i + 1] != null ? changeTimes[i + 1] : Math.POSITIVE_INFINITY;
        var frames = isPixel ? Paths.image("game/notes/" + skin) : Paths.getFrames("game/notes/" + skin);
        var scl = isPixel ? daPixelZoom : finalNotesScale;

        NoteReskinHelper.reskinNotes(
            strumLines.members,
            frames,
            time,
            endTime,
            isPixel,
            scl,
            skin == "default" ? 3.5 : 0,
            scrollSpeed,
            noteSkin,
            skin,
            scrollPrefixes,
            holdPrefixes,
            holdEndPrefixes,
            isPixel ? Paths.image("game/notes/" + skin + "_ENDs") : null
        );
    }
}

var lastProcessedSkinTime:Float = -1;

var strumAnimPrefix = ["left", "down", "up", "right"];
function onEvent(eventEvent) {
    if (eventEvent.event.name == "Change Strum Skin") {
        var eventTime:Float = eventEvent.event.time;
        if (eventTime == lastProcessedSkinTime) return;
        lastProcessedSkinTime = eventTime;

        var skin:String = eventEvent.event.params[0];
        var isPixel:Bool = eventEvent.event.params[1];

        var frames:Dynamic = isPixel ? Paths.image("game/notes/" + skin) : Paths.getFrames("game/notes/" + skin);

        // Notes were pre-reskinned at load time; only strum receptors need updating
        for (strumLine in strumLines.members) {
            for (i => strum in strumLine.members) {
                var oldAnimName:String = strum.animation.name;
                var oldAnimFrame:Int = strum.animation?.curAnim?.curFrame;
                if (oldAnimFrame == null) oldAnimFrame = 0;

                strum.frames = isPixel ? null : frames;
                strum.animation._animations.clear();
		        strum.animation._curAnim = null;

                if(isPixel){
                    strum.loadGraphic(frames, true, 17, 17);
                    strum.animation.add("static", [strum.ID]);
                    strum.animation.add("pressed", [4 + strum.ID, 8 + strum.ID], 12, false);
                    strum.animation.add("confirm", [12 + strum.ID, 16 + strum.ID], 24, false);
                    strum.antialiasing = false;
                } else {
                    strum.animation.addByPrefix('static', 'arrow' + strumAnimPrefix[i % strumAnimPrefix.length].toUpperCase(), true);
                    strum.animation.addByPrefix('pressed', strumAnimPrefix[i % strumAnimPrefix.length] + ' press', 24, false);
                    strum.animation.addByPrefix('confirm', strumAnimPrefix[i % strumAnimPrefix.length] + ' confirm', 24, false);
                    strum.antialiasing = Options.antialiasing;
                }

                strum.scale.set(isPixel ? daPixelZoom : finalNotesScale,isPixel ? daPixelZoom : finalNotesScale);
                strum.updateHitbox();

                strum.playAnim(oldAnimName, true);
                strum.animation?.curAnim?.curFrame = oldAnimFrame;
            }
        }
    }
}