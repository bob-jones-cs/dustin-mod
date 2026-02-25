// Script by bctix
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import flixel.text.FlxText.FlxTextAlign;

var lyricsConfig = {
    xOffset: 0,
    yOffset: 0,
    color: FlxColor.WHITE,
    borderColor: FlxColor.BLACK,
    font: "8bit-jve",
    size: 32,
    borderSize: 2,
    textSpaceMovementMult: 1, // Multiplier for how far the text history moves. make it -1 to move down
    showHistory: true
}

var textGroup:FlxTypedGroup;
var textPool:Array<FlxText> = [];
var __cachedFont:String;

function create()
{
    textGroup = new FlxTypedGroup();
    textGroup.cameras = [camHUD2];
    add(textGroup);
    __cachedFont = getFont();
    for (_ in 0...3) {
        var t = new FlxText(0, 500);
        t.cameras = [camHUD2];
        textPool.push(t);
    }
}

function onEvent(eventEvent) {
    if(eventEvent.event.name != "Lyrics") return;
    switch(eventEvent.event.params[0]) {
        case "Add Text":
            addText(eventEvent.event.params[1]);

        case "Force remove all text":
            killText();

        case "Set Color":
            lyricsConfig.color = eventEvent.event.params[2];

        case "Set Border Color":
            lyricsConfig.borderColor = eventEvent.event.params[2];

        case "Set Font":
            lyricsConfig.font = eventEvent.event.params[1];
            __cachedFont = getFont();

        case "Set Size":
            lyricsConfig.size = eventEvent.event.params[1];

        case "Enable text history (On, Off)":
            lyricsConfig.showHistory = eventEvent.event.params[3];

        case "Center":
            lyricsConfig.yOffset = -200;

        case "Cutscene":
            lyricsConfig.yOffset = 90;

        case "Ultra remove":
            killTextULTRA();

    }
}

function addText(setText)
{
    for(i in textGroup.members)
    {
        if(lyricsConfig.showHistory)
        {
            var spaceToMove = !camHUD.downscroll ? lyricsConfig.size : -1 * lyricsConfig.size;
            spaceToMove *= lyricsConfig.textSpaceMovementMult;
            FlxTween.tween(i, {alpha: i.alpha - 0.7, y: i.y - spaceToMove}, 0.3, {ease: FlxEase.cubeOut, onComplete: function(t){
                if(i.alpha == 0)
                {
                    textGroup.remove(i, true);
                    textPool.push(i);
                }
            }});
        }
    }

    if (!lyricsConfig.showHistory) {
        while (textGroup.members.length > 0) {
            var old = textGroup.members[0];
            textGroup.remove(old, true);
            textPool.push(old);
        }
    }

    var text:FlxText;
    if (textPool.length > 0) {
        text = textPool.pop();
        text.alpha = 1;
    } else {
        text = new FlxText(0, 500);
        text.cameras = [camHUD2];
    }
    text.setFormat(__cachedFont, lyricsConfig.size, lyricsConfig.color, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, lyricsConfig.borderColor);
    text.borderSize = lyricsConfig.borderSize;
    text.text = setText;
    text.screenCenter(FlxAxes.X);
    text.x += lyricsConfig.xOffset;
    text.y = 500 + lyricsConfig.yOffset;
    textGroup.add(text);
}

function getFont()
{
    if(StringTools.endsWith(lyricsConfig.font, ".ttf") || StringTools.endsWith(lyricsConfig.font, ".otf"))
        return Paths.font(lyricsConfig.font);

    if(Assets.exists(Paths.font(lyricsConfig.font) + ".ttf"))
        return Paths.font(lyricsConfig.font) + ".ttf";

    if(Assets.exists(Paths.font(lyricsConfig.font) + ".otf"))
        return Paths.font(lyricsConfig.font) + ".otf";
}

function killText()
{
    for(i in textGroup.members)
    {
        FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.cubeOut, onComplete: function(t){
            textGroup.remove(i, true);
            textPool.push(i);
        }});
    }
}

function killTextULTRA()
{
    while (textGroup.members.length > 0) {
        var i = textGroup.members[0];
        textGroup.remove(i, true);
        textPool.push(i);
    }
}
