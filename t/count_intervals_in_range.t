include ../../plugin_tap/procedures/more.proc
include ../procedures/count_intervals_in_range.proc

@plan: 4

if praatVersion >= 6036
  synth_language$ = "English (Great Britain)"
  synth_voice$ = "Male1"
else
  synth_language$ = "English"
  synth_voice$ = "default"
endif

synth = Create SpeechSynthesizer: synth_language$, synth_voice$
To Sound: "This is some text", "yes"

sound    = selected("Sound")
textgrid = selected("TextGrid")

selectObject: textgrid
tiers = Get number of tiers
intervals = Get number of intervals: tiers

Insert point tier: tiers + 1, "points"

@countIntervalsInRange: tiers, 0, 0
@is: intervals, countIntervalsInRange.return,
  ... "count intervals in range"

@countIntervalsInRange: tiers + 1, 0, 0
@is: countIntervalsInRange.return, undefined,
  ... "intervals undefined in point tier"

Insert interval tier: 1, "empty"

@countIntervalsInRange: 1, 0, 0
@is: countIntervalsInRange.return, 1,
  ... "empty tier has one interval"

removeObject: sound, textgrid, synth

@ok_selection()

@done_testing()
