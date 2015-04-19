// @title HeirloomTech Laser Cutter
// @author Timothy Schmidt, 2015 
// @license https://www.gnu.org/licenses/agpl-3.0.html
// @license http://www.tapr.org/TAPR_Open_Hardware_License_v1.0.txt
// @git http://github.com/timschmidt/heirloomtech
// @tags Logo,Intersection,Sphere,Cube

function main() {
   return union(
      difference(
         cube({size: 3.2, center: true}),
         sphere({r:2, center: true})
      ),
      intersection(
          sphere({r: 1.3, center: true}),
          cube({size: 2.1, center: true})
      )
   ).translate([0,0,1.5]).scale(10);
}
