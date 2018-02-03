include ../../plugin_tap/procedures/more.proc
include ../../plugin_tgutils/procedures/get_tier_by_name.proc

@plan(16)

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

sound    = selected("Sound")
textgrid = selected("TextGrid")

selectObject: textgrid
tiers = Get number of tiers
segment_tier = 4
segments = Get number of intervals: segment_tier

Insert point tier: tiers + 1, "points"
for i to segments-1
  time = Get end point: segment_tier, i
  Insert point: tiers + 1, time, string$(i)
endfor

@getTierByName: "clause"
@is: getTierByName.return, 2,
  ... "finds existing interval tier"

@getTierByName: "points"
@is: getTierByName.return, 5,
  ... "finds existing point tier"

@getTierByName: "fake"
@is_false: getTierByName.return,
  ... "does not find missing tier"

@getTierByName: ""
@is_false: getTierByName.return,
  ... "does not find tier with empty string"

Set tier name: 5, "añejó"

@getTierByName: "añejó"
@is: getTierByName.return, 5,
  ... "finds tier with unicode string"

Set tier name: 5, "あいうえお"

@getTierByName: "あいうえお"
@is: getTierByName.return, 5,
  ... "finds tier with hiragana string"

Set tier name: 5, "音声学"

@getTierByName: "音声学"
@is: getTierByName.return, 5,
  ... "finds tier with kanji string"

Set tier name: 5, "points"

# Scripts

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", "clause"
@is: number(info$()), 2,
  ... "script finds existing interval tier"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name_regex.praat", "a?[pl]ause$"
@is: number(info$()), 2,
  ... "script finds tier using regular expression"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", "points"
@is: number(info$()), 5,
  ... "script finds existing point tier"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", "fake"
@is: number(info$()), 0,
  ... "script does not find missing tier"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", ""
@is: number(info$()), 0,
  ... "script does not find tier with empty string"

Set tier name: 5, "añejó"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", "añejó"
@is: number(info$()),  5,
  ... "script finds tier with unicode string"

Set tier name: 5, "あいうえお"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", "あいうえお"
@is: number(info$()),  5,
  ... "script finds tier with hiragana string"

Set tier name: 5, "音声学"

appendInfo: "# "
runScript: tgutils$ + "get_tier_by_name.praat", "音声学"
@is: number(info$()), 5,
  ... "script finds tier with kanji string"

removeObject: sound, textgrid, synth

@ok_selection()

@done_testing()
