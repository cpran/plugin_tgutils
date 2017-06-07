# This script is part of the tgutils CPrAN plugin for Praat.
# The latest version is available through CPrAN or at
# <http://cpran.net/plugins/tgutils>
#
# The tgutils plugin is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# The tgutils plugin is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with tgutils. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2017 Jose Joaquin Atria

#! ~~~params
#! selection:
#!   in:
#!     - textgrid: 1
#!     - duration_tier: 1
#!   out:
#!     - textgrid: 1
#! ~~~
#!
#! Applies the duration manipulations of a DurationTier to a TextGrid
#! object. This will adjust the timestamps of all interval boundaries
#! and points in all tiers to fit the curve of the DurationTier.
#!
#! The modified TextGrid will be selected at the end. The name will be
#! the same as that of the original TextGrid, with the "_duration" suffix.
#!

total_textgrids = numberOfSelected("TextGrid")
for i to total_textgrids
  textgrid[i] = selected("TextGrid", i)
endfor

duration_tier = selected("DurationTier")

for i to total_textgrids
  selectObject: textgrid[i]
  result[i] = Copy: selected$("TextGrid") + "_duration"

  original_start    = Get start time
  original_end      = Get end time
  original_duration = Get total duration

  selectObject: duration_tier
  has_points      = Get number of points
  if has_points
    target_duration   = Get target duration: original_start, original_end
    target_start      = original_start
    target_end        = original_start + target_duration

    time_difference   = target_duration - original_duration

    selectObject: result[i]
    Scale times to: target_start, target_end

    for tier to do("Get number of tiers")
      selectObject: result[i]
      is_interval = Is interval tier: tier
      if is_interval
        item$ = "interval"
        time_query$ = "Get starting point..."
      else
        item$ = "point"
        time_query$ = "Get time of point..."
      endif

      items = do("Get number of " + item$ + "s...", tier)

      for j from 0 to items - 1
        item = items - j

        selectObject: textgrid[i]
        old_time = do(time_query$, tier, item)
        label$ = do$("Get label of " + item$ + "...", tier, item)

        selectObject: duration_tier
        new_time = Get target duration: original_start, old_time

        selectObject: result[i]
        if is_interval
          if item > 1
            Set interval text: tier, item, ""
            Remove left boundary: tier, item
            Insert boundary: tier, new_time
            Set interval text: tier, item, label$
          endif
        else
          Remove point: tier, item
          nocheck Insert point: tier, item, new_time
          Set point label: tier, item, label$
        endif
      endfor
    endif
  endfor
endfor

selectObject()
for i to total_textgrids
  plusObject: result[i]
endfor
