include ../../plugin_tap/procedures/more.proc
include ../procedures/count_points_in_range.proc

@plan: 4

synth = Create SpeechSynthesizer: "English", "default"
To Sound: "This is some text", "yes"

sound    = selected("Sound")
textgrid = selected("TextGrid")

selectObject: textgrid
tiers = Get number of tiers
intervals = Get number of intervals: 1

Insert point tier: tiers + 1, "points"

@countPointsInRange: tiers + 1, 0, 0
@is: countPointsInRange.return, 0,
  ... "empty tier has zero points"

for i to intervals-1
  time = Get end point: 1, i
  Insert point: tiers + 1, time, ""
endfor

@countPointsInRange: tiers + 1, 0, 0
@is: intervals, countPointsInRange.return + 1,
  ... "count points in range"

@countPointsInRange: 1, 0, 0
@is: countPointsInRange.return, undefined,
  ... "points undefined in interval tier"

removeObject: sound, textgrid, synth

@ok_selection()

@done_testing()
