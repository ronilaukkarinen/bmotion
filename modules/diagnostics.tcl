# bMotion - Diagnostics
#
# $Id$
#

###############################################################################
# bMotion - an 'AI' TCL script for eggdrops
# Copyright (C) James Michael Seward 2000-2002
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or 
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program; if not, write to the Free Software 
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
###############################################################################

#
# Check if a channel has uppercase letters in it
#
proc bMotion_diagnostic_channel1 { } {
  global bMotionInfo

  set err 0
  set cleanChannels [list]
  foreach chan $bMotionInfo(randomChannels) {
    set chan2 [string tolower $chan]
    if {$chan != $chan2} {
      #case difference
      set err 1
    }
    lappend cleanChannels $chan2
  }
  set bMotionInfo(randomChannels) $cleanChannels

  if {$err == 1} {
    bMotion_putloglev d * "Self-diagnostics indicate you have a channel with a captial letter in in your settings file."
    bMotion_putloglev d * "  This has been fixed on the fly at load time, but you will need to edit the settings file"
    bMotion_putloglev d * "  to prevent this reoccuring. Please use all lower-case characters for defining channels."
  }
}

#
# Check the bot's configured for all the channels in the list
proc bMotion_diagnostic_channel2 { } {
  global bMotionInfo

  set notOnChans ""
  set botChans [list]
  foreach chan [channels] {
    lappend botChans [string tolower $chan]
  }

  foreach chan $bMotionInfo(randomChannels) {
    if {[lsearch -exact $botChans $chan] < 0} {
      #configured chan the bot doesn't know about
      append notOnChans "$chan "
    }
  }
  if {$notOnChans != ""} {
    bMotion_putloglev d * "The following channels are in the settings file, but not configured in eggdrop (typos?): $notOnChans"
  }
}


bMotion_putloglev d * "Running a level 5 self-diagnostic..."

bMotion_diagnostic_channel1
bMotion_diagnostic_channel2

bMotion_putloglev d * "Diagnostics complete."