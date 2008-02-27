var tl;
function onLoad() {
    var eventSource = new Timeline.DefaultEventSource(0);
    
    var theme = Timeline.ClassicTheme.create();
    theme.event.bubble.width = 320;
    theme.event.bubble.height = 220;
    var d = new Date();
    var bandInfos = [
        Timeline.createBandInfo({
            width:          "70%", 
            intervalUnit:   Timeline.DateTime.MONTH, 
            intervalPixels: 100,
            eventSource:    eventSource,
            date:           d,
            theme:          theme
        }),
        Timeline.createBandInfo({
            width:          "30%", 
            intervalUnit:   Timeline.DateTime.YEAR, 
            intervalPixels: 200,
            eventSource:    eventSource,
            date:           d,
            theme:          theme,
            showEventText:  false,
            trackHeight:    0.5,
            trackGap:       0.2,                 
        })
    ];
    bandInfos[1].syncWith = 0;
    bandInfos[1].highlight = true;
    
    tl = Timeline.create(document.getElementById("my-timeline"), bandInfos, Timeline.HORIZONTAL);
    Timeline.loadJSON("/timeline/show_calendar", function(json, url) {
        eventSource.loadJSON(json, url);
    });
}
var resizeTimerID = null;
function onResize() {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
            tl.layout();
        }, 500);
    }
}

function centerTimeline(date) {
 tl.getBand(0).setCenterVisibleDate(Timeline.DateTime.parseGregorianDateTime(date));
}