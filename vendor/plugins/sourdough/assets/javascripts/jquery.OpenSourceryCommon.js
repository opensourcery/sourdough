/* 
 * Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html
 *
 * This file contains common helper code for jQuery.
 */

// namespace:  OpenSourceryCommon
var OSC = new Object()

// id from ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// snarfs the id from a string as the string after the last underscore.  e.g.,
// - date_123     : returns "123"
// - foo_bar_baz  : returns "baz"
OSC.id_from = function( element ) {
  var parts = element.attr( 'id' ).split( '_' )
  return parts[ parts.length - 1 ]
}
