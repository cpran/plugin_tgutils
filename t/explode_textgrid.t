include ../../plugin_tap/procedures/more.proc
include ../procedures/find_label.proc

@plan: 3

if praatVersion >= 6036
  synth_language$ = "English (Great Britain)"
  synth_voice$ = "Male1"
else
  synth_language$ = "English"
  synth_voice$ = "default"
endif

synth = Create SpeechSynthesizer: synth_language$, synth_voice$
To Sound: "This is some text", "yes"

word_tier    = 3
segment_tier = 4

sound    = selected("Sound")
textgrid = selected("TextGrid")

selectObject: textgrid
intervals = Get number of intervals: word_tier
runScript: preferencesDirectory$ +
  ... "/plugin_tgutils/scripts/explode_textgrid.praat", word_tier, "no"

@is: numberOfSelected("TextGrid"), intervals,
  ... "explode textgrid"

Remove

selectObject: sound, textgrid
runScript: preferencesDirectory$ +
  ... "/plugin_tgutils/scripts/explode_textgrid.praat", word_tier, "no"

test = numberOfSelected("TextGrid") == intervals and
  ...  numberOfSelected("Sound")    == intervals
@is_true: test, "explode textgrid and sound"

Remove

removeObject: sound, textgrid, synth

@ok_selection()

@done_testing()
