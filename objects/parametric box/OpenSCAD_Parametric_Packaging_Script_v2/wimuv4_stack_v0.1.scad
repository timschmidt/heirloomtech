 /*!
@brief 25mm Mote layer Battery
@details This OpenSCAD script will generate a tyndall 25mm mote battery layer based on autocad dxf drawing 25mmmotelayerzigbee2.dxf

@author Mark Gaffney
@version 0.1
@date 2013_03_28 ISO Standard YYYY_MM_DD format

@todo

@warning
This is not for printing but more so for getting a general idea of whether or not your enclosure will fit Tyndall motes correctly

@note

v0.1
 - 	first attempt based on 25mm_mote_layer_battery_v0.3.scad
Changes from previous versions:
0.3 2013_03_28
 - 	added functionality and control for switch
 - 	DXF seems to be generating strange geometry, perhaps openscad's dxf support has been changed or file is corrupted?
0.2
 - secodn attempt based on v0.3
0.1
 - 	first attempt based on 25mm_mote_layer_zigbee_v0.2.scad

@attention
Copyright (c) 2011 Tyndall National Institute.
All rights reserved.
Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without written agreement is hereby granted, provided that the above copyright notice and the following two paragraphs appear in all copies of this software. 

IN NO EVENT SHALL TYNDALL NATIONAL INSTITUTE BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF TYNDALL NATIONAL INSTITUTE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

TYNDALL NATIONAL INSTITUTE SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND TYNDALL NATIONAL INSTITUTE HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
*/

//***********Pre*Defined*Variables**************
a_bit=0.01;//This is used to help with manifoldness during difference operations

//h_PCB=1.2;
h_PCB=1.3;

e_antenna=0.9;
//**************User*Variables*****************
expand = [0.1,0.1,0.1];//how much larger should I make things in each direction?
has_antenna=0;
has_uUSB=1;
has_battery=true;
has_battery_top=0;
has_switch=1;
switch_state=0;//0,1

bottom_comp_max_h = 2.15;//uSD holder
top_comp_max_h = 3.1;

//bottom components

usd_size_lbh =[14.05,15.25,2.15];
usd_off_xyz =[17.58,11.55,0];

//atmel
atmel_size_lbh=[9.8,9.8,1.1];
atmel_off_xyz=[3.2,5.3,0];

//orientation1
battery_bottom_size_lbh=[20,26,4.2];
//battery_bottom_size_lbh=[20.5,26.5,4.4];//with a bit extra
battery_bottom_off_xyz=[5,1,bottom_comp_max_h];
//battery_bottom_off_xyz=[5,1,bottom_comp_max_h-0.2];////with a bit extra
//orientation2
//battery_bottom_size_lbh=[26,20,4.2];
//battery_bottom_off_xyz=[5,1,bottom_comp_max_h];

//has_underneath switches=true
//reset_switch
reset_switch_size_lbh=[3.1,3.55,1.76];
reset_switch_off_xyz=[28.57,1.38,0];
//bootload_switch
bootload_switch_size_lbh=[3.1,3.55,1.76];
bootload_switch_off_xyz=[28.57,6.91,0];

//top components

//orientation3
//battery_top_size_lbh=[20,26,4.2];
//battery_top_off_xyz=[5,1,top_comp_max_h];
//orientation4
//battery_top_size_lbh=[26,20,4.2];
//battery_top_off_xyz=[5,1,top_comp_max_h];

//single chip imu Invensense MPU 9150
mpu_size_lbh=[4,4,1.15];
mpu_off_xyz=[5.9,2.7,0];

usb_size_lbh=[5.55,8,3];
usb_off_xyz=[-0.78,6.93,-0.3];

switch_size_lbh =[3.5,8,3.5];
switch_off_xyz =[-1.4,19.5,0];

//Redpine wifi board parts
has_wifi=1;
wifi_pcb_size_lbh=[28.6,22,1.1];
wifi_pcb_off_xyz=[12,0.7,0];
	//wifi_led1
wifi_led1_size_lbh=[0.88,1.32,0.88];
wifi_led1_off_xyz=[2.65,1,0];
	//wifi_led2
wifi_led2_size_lbh=[1.32,0.88,0.88];
wifi_led2_off_xyz=[15.4,12,0];
	//wifi chip
wifi_chip_size_lbh=[13.2,12,1.9];
wifi_chip_off_xyz=[1.5,3.75,0];
	//wifi antenna
wifi_ant_size_lbh=[6.4,2,1.15];
wifi_ant_off_xyz=[20.4,13.4,0];

use <WIMUv4pcbv1.scad>;
//*********************Calls*******************
translate(v=[0,0,0]){
	wimuv4_2013_device(has_uUSB, has_battery,has_switch);
}

//*********************Modules******************* 
module wimuv4_2013_device(has_uUSB_l,has_battery_l,has_switch_l) {
	translate(v=[0,0,0]){
		wimuv4_2013_pcb();

//top components
		translate(v=[0,0,h_PCB]){

			if(has_battery && has_battery_top==1) translate(v=battery_top_off_xyz) color("cyan")cube(size=battery_top_size_lbh,center=false);
			translate(v=mpu_off_xyz) color("green")cube(size=mpu_size_lbh,center=false); //MPU single chip IMU  

			if(has_wifi==1) translate(v=wifi_pcb_off_xyz) color("red"){
				translate(v=-expand/2) cube(size=wifi_pcb_size_lbh + expand,center=false); //WiFi module PCB
				translate(v=[0,0,wifi_pcb_size_lbh[2]]){
					translate(v=wifi_chip_off_xyz) 	cube(size=wifi_chip_size_lbh +expand,center=false); //WiFi 
					translate(v=wifi_ant_off_xyz) 	cube(size=wifi_ant_size_lbh +expand,center=false); //WiFi 
					translate(v=wifi_led1_off_xyz) 	cube(size=wifi_led1_size_lbh +expand,center=false); //WiFi 
					translate(v=wifi_led2_off_xyz) 	cube(size=wifi_led2_size_lbh +expand,center=false); //WiFi 
	
	//				translate(v=wifi_ _off_xyz) cube(size=wifi_ _size_lbh,center=false); //WiFi 
				}
			}
			if(has_uUSB_l==1) translate(v=usb_off_xyz) color("grey")cube(size=usb_size_lbh+expand,center=false); //uUSB
	
			if(has_switch_l==1)translate(v=switch_off_xyz){
				echo("has switch");
				mirror(v=[1,0,0]) translate(v=[0,(switch_size_lbh[1]-2)/2 + switch_state*2,(switch_size_lbh[2]-2)/2]) color("black") cube(size=2,center=false);
				color("silver") cube(size=switch_size_lbh + expand,center=false);
			}
		}
//otherwise bottom component
		mirror(v=[0,0,1]){
			if(has_battery && has_battery_top==0) translate(v=battery_bottom_off_xyz) color("cyan")cube(size=battery_bottom_size_lbh + expand,center=false);

			translate(v=usd_off_xyz) color("blue") cube(size=usd_size_lbh + expand,center=false);//uSD card slot
			translate(v=atmel_off_xyz) color("orange") cube(size=atmel_size_lbh + expand,center=false);//atmel chip
			translate(v=reset_switch_off_xyz) {
				color("violet") cube(size=reset_switch_size_lbh + expand,center=false);
				color("black") translate(v=[reset_switch_size_lbh[0],(reset_switch_size_lbh[1]-2)/2,0])cube(size=[0.6,2,1.5],center=false);
			}
			translate(v=bootload_switch_off_xyz) {
				color("indigo") cube(size=bootload_switch_size_lbh + expand,center=false);
				color("black") translate(v=[bootload_switch_size_lbh[0],(bootload_switch_size_lbh[1]-2)/2,0])cube(size=[0.6,2,1.5],center=false);
			}

		}
	}
}

