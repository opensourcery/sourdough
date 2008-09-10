# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
# Include hook code here
require 'sourdough'
load_paths.each do |path|
  Dependencies.load_once_paths.delete(path)
end
