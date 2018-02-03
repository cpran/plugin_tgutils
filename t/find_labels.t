include ../../plugin_tap/procedures/more.proc
include ../procedures/find_label.proc

@plan: 35

if praatVersion >= 6036
  synth_language$ = "English (Great Britain)"
  synth_voice$ = "Male1"
else
  synth_language$ = "English"
  synth_voice$ = "default"
endif

synth = Create SpeechSynthesizer: synth_language$, synth_voice$
tgutils$ = preferencesDirectory$ + "/plugin_tgutils/scripts/"
To Sound: "This is some text", "yes"

word_tier    = 3
segment_tier = 4

sound    = selected("Sound")
textgrid = selected("TextGrid")

selectObject: textgrid
tiers = Get number of tiers
segments = Get number of intervals: segment_tier

Insert point tier: tiers + 1, "points"
for i to segments-1
  time = Get end point: 4, i
  Insert point: tiers + 1, time, string$(i)
endfor

point_tier   = 5

@findLabel: segment_tier, "s"
@is: findLabel.return, 4,
  ... "finds existing label index"
@is$: findLabel.label$, "s",
  ... "finds existing label string"

@findLabel: segment_tier, "x"
@is: findLabel.return, 0,
  ... "cannot find missing label"
@is$: findLabel.label$, string$(undefined),
  ... "missing label string is undefined"

@findLabel: word_tier, "hi"
@is$: do$("Get label of interval...", word_tier, findLabel.return), "This",
  ... "label is regular expression"
@is$: findLabel.label$, "This",
  ... "returned label string with regex"

find_label.regex = 0
@findLabel: word_tier, "hi"
@is: findLabel.return, 0,
  ... "label is not regular expression"

@findLabelAhead: segment_tier, "s", 1
@isnt: findLabelAhead.return, 0,
  ... "find label index from start"
@is$: findLabelAhead.label$, "s",
  ... "find label string from start"

@findLabelBehind: segment_tier, "s", 5
@is: findLabelBehind.return, 4,
  ... "find label index from end, counting forward"
@is$: findLabelBehind.label$, "s",
  ... "find label string from end, counting forward"

@findLabelBehind: segment_tier, "s", -1
@is: findLabelBehind.return, 16,
  ... "find label from end, counting backwards"
@is$: findLabelBehind.label$, "s",
  ... "find label string from end, counting backwards"

@isnt: findLabelBehind.return, findLabelAhead.return,
  ... "from start and end differ in same direction"

first = findLabelAhead.return

@findLabelAhead: segment_tier, "s", first + 1
@isnt: findLabelAhead.return, 0,
  ... "finds ahead after offset"
@cmp_ok: findLabelAhead.return, ">", first,
  ... "finds next after first"

second = findLabelAhead.return

@findNthLabel: segment_tier, "s", 2
@isnt: findNthLabel.return, 0,
  ... "finds nth label"
@is: findNthLabel.return, second,
  ... "2nd label is first after first"

@findNthLabel: segment_tier, "s", 0
@is: findNthLabel.return, undefined,
  ... "0th element is undefined"

@findLabel: segment_tier, "ɪ"
@isnt: findLabel.return, 0,
  ... "find unicode label"

@findLabel: point_tier, "2"
@isnt: findLabel.return, 0,
  ... "find point labels"

# Scripts

appendInfo: "# "
nocheck runScript: tgutils$ + "find_label_in_textgrid.praat",
  ... segment_tier, "s", "Forwards", 1
@is: number(info$()), 4,
  ... "script finds label forward"

appendInfo: "# "
runScript: tgutils$ + "find_label_in_textgrid.praat",
  ... segment_tier, "s", "Backwards", 1
@is: number(info$()), 0,
  ... "script doesn't find label from start, counting backwards"

appendInfo: "# "
runScript: tgutils$ + "find_label_in_textgrid.praat",
  ... segment_tier, "s", "Backwards", -1
@is: number(info$()), 16,
  ... "script finds label from end, counting backwards"

appendInfo: "# "
runScript: tgutils$ + "find_label_in_textgrid.praat",
  ... segment_tier, "x", "Forwards", 1
@is: number(info$()), 0,
  ... "script doesn't find missing label from start, counting forward"

appendInfo: "# "
runScript: tgutils$ + "find_label_in_textgrid.praat",
  ... segment_tier, "x", "Backwards", -1
@is: number(info$()), 0,
  ... "script doesn't find missing label from end, counting backwards"

appendInfo: "# "
runScript: tgutils$ + "find_label_ahead.praat",
  ... segment_tier, "s", 1
@is: number(info$()), 4,
  ... "script finds label ahead from start"

appendInfo: "# "
runScript: tgutils$ + "find_label_ahead.praat",
  ... segment_tier, "s", -1
@is: number(info$()), 0,
  ... "script finds label ahead from end"

appendInfo: "# "
runScript: tgutils$ + "find_label_ahead.praat",
  ... segment_tier, "x", 1
@is: number(info$()), 0,
  ... "script doesn't find missing label ahead from start"

appendInfo: "# "
runScript: tgutils$ + "find_label_ahead.praat",
  ... segment_tier, "x", -1
@is: number(info$()), 0,
  ... "script doesn't find missing label ahead from end"

appendInfo: "# "
runScript: tgutils$ + "find_label_behind.praat",
  ... segment_tier, "s", 1
@is: number(info$()), 0,
  ... "script doesn't find label behind from start"

appendInfo: "# "
runScript: tgutils$ + "find_label_behind.praat",
  ... segment_tier, "s", -1
@is: number(info$()), 16,
  ... "script finds label behind from end"

appendInfo: "# "
runScript: tgutils$ + "find_label_behind.praat",
  ... segment_tier, "x", 1
@is: number(info$()), 0,
  ... "script doesn't find missing label behind from start"

appendInfo: "# "
runScript: tgutils$ + "find_label_behind.praat",
  ... segment_tier, "x", -1
@is: number(info$()), 0,
  ... "script doesn't find missing label behind from end"

removeObject: sound, textgrid, synth

@ok_selection()

@done_testing()
