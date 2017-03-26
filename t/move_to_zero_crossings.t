include ../../plugin_tap/procedures/more.proc
include ../procedures/move_to_zero_crossings.proc

@plan: 5

synth = Create SpeechSynthesizer: "English", "default"
To Sound: "This is some text", "yes"

sound    = selected("Sound")
textgrid = selected("TextGrid")

selectObject: textgrid
tiers = Get number of tiers
intervals = Get number of intervals: 4

Insert point tier: tiers + 1, "points"
for i to intervals-1
  time = Get end point: 4, i
  Insert point: tiers + 1, time, string$(i)
endfor

selectObject: sound, textgrid
@check_crossings: 3
@is_false: check_crossings.return,
  ... "not all boundaries at zero"

@moveToZeroCrossings: 3, 0
@check_crossings: 3
@is_true: check_crossings.return,
  ... "all boundaries at zero"

@check_crossings: 4
@is_false: check_crossings.return,
  ... "not all points at zero"

@moveToZeroCrossings: 4, 0
@check_crossings: 4
@is_true: check_crossings.return,
  ... "all points at zero"

removeObject: sound, textgrid, synth

@ok_selection()

@done_testing()

procedure check_crossings: .tier
  .textgrid = selected("TextGrid")
  .sound = selected("Sound")

  .return = 1

  selectObject: .textgrid
  .interval = Is interval tier: .tier
  if .interval
    .command$ = "Get end point..."
    .end = Get number of intervals: .tier
    .end -= 1
  else
    .end = Get unumber of points: .tier
    .command$ = "Get time of point..."
  endif

  for .i to .end
    selectObject: .textgrid
    .time = do(.command$, .tier, .i)

    selectObject: .sound
    .zero = Get nearest zero crossing: 1, .time
    # @diag: "  " + string$(.time) + " ~ " + string$(.zero)
    if .zero != .time
      .return = 0
    endif
  endfor

  selectObject: .sound, .textgrid
endproc
