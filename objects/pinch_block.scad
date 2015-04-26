/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>
*/

bolt_diameter = 5/16 * 25.4;
bar_diameter = 25.4/2;
bolt_spacing = 1.5 * 25.4;
split_width = 4;
block_width = 25.4 / 2;

difference() {
cube ( [bolt_spacing + block_width, block_width, bar_diameter +split_width], center = true );
  translate( [bolt_spacing / 2,0,0] ) {
    cylinder ( h = bar_diameter + split_width + 2, r = bolt_diameter / 2, center = true);
  }
  translate( [-bolt_spacing / 2,0,0] ) {
    cylinder ( h = bar_diameter + split_width + 2, r = bolt_diameter / 2, center = true);
  }
  rotate( [90,0,0]) {
    cylinder ( h = block_width + 2, r = bar_diameter / 2, center = true);
  }
  translate([bolt_spacing / 4 + block_width / 4, 0, 0]) {
    cube([bolt_spacing / 2 + block_width / 2 + 2, block_width + 2, split_width], center = true);
  }
};