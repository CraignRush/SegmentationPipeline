// Here are all intermediate files generated
condition_dir = "/Volumes/msdata/flwilfli/Lab/users/Jeremy/Nikon/GFP-Ede1-GFP+3xGBP_20h_Rapa_starvation/20hRapa/";

run("Close All");
//setBatchMode("hide");
list = getFileList(condition_dir);
list = Array.sort(list);
for (i = 0; i < list.length; i++) {
	
	if(File.isDirectory(condition_dir + list[i]))
		print(condition_dir + list[i]);
		processFolder(condition_dir + list[i]);
		//break;
}

function processFolder(input) {	
	File.makeDirectory(input + "cells/");
	File.makeDirectory(input + "cells_mask/");
	File.makeDirectory(input + "punctae/");
	File.makeDirectory(input + "punctae_mask/");	
	File.makeDirectory(input + "Results/");
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		print(input + list[i]);
		print(input  + "punctae/" + list[i]);
		if(endsWith(list[i], ".nd2"))
			File.rename(input + list[i], input + "punctae/" + list[i]);
		if(endsWith(list[i], ".tiff"))
			File.rename(input + list[i], input + "cells/" + list[i]);	
	}
	cell_img_dir =  input + "cells/";
	punctae_img_dir = input + "punctae/";
	
	cell_imgs = getFileList(cell_img_dir);
	punctae_imgs = getFileList(punctae_img_dir);
	
	for (i = 0; i < lengthOf(cell_imgs); i++) {
		if (!endsWith(cell_imgs[i], "tiff")){
			continue;
			}	
		run("Close All");
		curr_img_name = cell_imgs[i];
		open(cell_img_dir + curr_img_name);			
		Stack.setXUnit("micron");
		Stack.setYUnit("micron");
		Stack.setZUnit("micron");
		run("Properties...", "channels=1 slices=1 frames=1 pixel_width=0.0650000 pixel_height=0.0650000 voxel_depth=0.0650000");
		run("Save");
		run("8-bit");
		setAutoThreshold("Default");
		//run("Threshold...");	
		setOption("BlackBackground", false);
		run("Convert to Mask");	
		//run("Close");
		run("Set Measurements...", "area mean min centroid fit display add redirect=None decimal=6");
		run("Analyze Particles...", "size=4-Infinity show=[Bare Outlines] display exclude clear add");
		//setOption("ScaleConversions", true);	
		//print(input + "cells_mask/" + curr_img_name + "_mask.tif");
		saveAs("Tiff", input + "cells_mask/" + curr_img_name + "_mask.tif");
		//run("Close");
		//roiManager("Measure");
		saveAs("Results", input + "Results/" + "Results_cells_" + curr_img_name + ".csv");
		run("Close All");
		
		open(punctae_img_dir + punctae_imgs[i]);			
		run("Split Channels");
		curr_img_name = "C2-" + punctae_imgs[i];
		selectWindow(curr_img_name);		
		saveAs("Tiff", punctae_img_dir + curr_img_name + ".tif");
		
		curr_img_name = curr_img_name + ".tif";
		selectWindow(curr_img_name);
		run("Duplicate...", "title=duplicate");
		run("Gaussian Blur...", "sigma=8");
		//selectWindow("C2-20230221_20hRapa_FW_Y6612+pCUP_BFP-3xGBP_012.nd2");
		imageCalculator("Subtract create", curr_img_name,"duplicate");
		selectWindow("Result of " + curr_img_name);
		run("Brightness/Contrast...");
		setMinAndMax(750, 800);
		run("Apply LUT");
		run("Convert to Mask");
		
		//setAutoThreshold("Triangle dark");
		//setOption("BlackBackground", true);
		//run("Convert to Mask");
		run("Set Measurements...", "area mean min centroid fit display add redirect=None decimal=6");
		run("Analyze Particles...", "size=0.1-Infinity show=[Bare Outlines] display exclude clear add");
		//setOption("ScaleConversions", true);
		saveAs("Tiff", input + "punctae_mask/" + curr_img_name + "_mask_try.tif");
		saveAs("Results", input + "Results/" + "Results_punctae_"+ curr_img_name +".csv");
		//break;
		run("Close All");
		}
}