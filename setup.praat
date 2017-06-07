# Setup script for tgutils
#
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
# Copyright 2014 - 2016 Jose Joaquin Atria

## Static commands:

if fileReadable(preferencesDirectory$ + "/plugin_vieweach")
  # Base menu (only if the vieweach plugin is installed)
  nocheck Add menu command: "Objects", "Praat", "tgutils", "CPrAN", 1, ""

  # Batch scripts menu (only if the vieweach plugin is installed)
  nocheck Add menu command: "Objects", "Praat", "Make tier times equal (batch)...",             "tgutils", 2, "scripts/batch_make_tier_times_equal.praat"
  nocheck Add menu command: "Objects", "Praat", "TextGrids to Audacity labels (batch)...",      "tgutils", 2, "scripts/batch_textgrids_to_audacity_labels.praat"
  nocheck Add menu command: "Objects", "Praat", "Move boundaries to zero-crossings (batch)...", "tgutils", 2, "scripts/batch_move_to_zero_crossings.praat"
endif

## Dynamic commands

# TextGrid commands
Add action command: "TextGrid", 1, "",          0, "", 0, "Find label...",                        "Query -",          1, "scripts/find_label_in_textgrid.praat"
Add action command: "TextGrid", 1, "",          0, "", 0, "Index specified labels...",            "Query -",          1, "scripts/index_specified_labels.praat"
Add action command: "TextGrid", 1, "",          0, "", 0, "Get tier by name...",                  "Query -",          1, "scripts/get_tier_by_name.praat"
Add action command: "TextGrid", 0, "",          0, "", 0, "Save as Audacity label...",            "",                 0, "scripts/textgrid_to_audacity_label.praat"
Add action command: "TextGrid", 1, "",          0, "", 0, "Count points in range...",             "Query point tier", 2, "scripts/count_points_in_range.praat"
Add action command: "TextGrid", 1, "",          0, "", 0, "Explode TextGrid...",                  "",                 0, "scripts/explode_textgrid.praat"
Add action command: "TextGrid", 1, "Sound",     1, "", 0, "Explode TextGrid...",                  "",                 0, "scripts/explode_textgrid.praat"
Add action command: "TextGrid", 1, "Sound",     1, "", 0, "Move boundaries to zero crossings...", "Modify times",     2, "scripts/move_to_zero_crossings.praat"
Add action command: "TextGrid", 1, "Sound",     1, "", 0, "Extract labels...",                    "",                 0, "scripts/extract_labels.praat"
Add action command: "TextGrid", 1, "LongSound", 1, "", 0, "Extract labels...",                    "",                 0, "scripts/extract_labels.praat"
Add action command: "TextGrid", 0, "",          0, "", 0, "To non-overlapping intervals",         "",                 0, "scripts/to_non-overlapping_intervals.praat"

Add action command: "TextGrid", 0, "DurationTier", 1, "", 0, "Apply to TextGrid", "", 0, "scripts/apply_duration_tier.praat"
