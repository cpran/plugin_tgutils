include ../../plugin_tap/procedures/more.proc

@no_plan()

if praatVersion >= 6036
  synth_language$ = "English (Great Britain)"
  synth_voice$ = "Male1"
else
  synth_language$ = "English"
  synth_voice$ = "default"
endif

synth = Create SpeechSynthesizer: synth_language$, synth_voice$
To Sound: "This is some text", "yes"
sound = selected("Sound")
textgrid = selected("TextGrid")
textgrid$ = selected$("TextGrid")

selectObject: sound
manipulation = To Manipulation: 0.01, 75, 600
duration_tier = Extract duration tier
Add point: 0, 1
Add point: do("Get total duration"), 2

selectObject: manipulation, duration_tier
Replace duration tier

selectObject: manipulation
new_sound = Get resynthesis (overlap-add)
new_duration = Get total duration

selectObject: textgrid, duration_tier
runScript: preferencesDirectory$ + "/plugin_tgutils/scripts/apply_duration_tier.praat"
new_textgrid = selected("TextGrid")

@is$: selected$("TextGrid"), textgrid$ + "_duration", "Appended suffix"
@is:  do("Get total duration"), new_duration, "Scaled total duration"

selectObject: textgrid
old_time = Get end point: 3, 4
selectObject: new_textgrid
new_time = Get end point: 3, 4

@cmp_ok: old_time, "<", new_time, "Modified times"

removeObject: manipulation, duration_tier, sound, textgrid, synth, new_sound, new_textgrid
@ok_selection()

@done_testing()
