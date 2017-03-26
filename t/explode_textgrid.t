include ../../plugin_tap/procedures/more.proc
include ../procedures/find_label.proc

@plan: 3

synth = Create SpeechSynthesizer: "English", "default"
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
