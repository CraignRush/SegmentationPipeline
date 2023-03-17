#!/usr/bin/env python
# coding: utf-8

# In[23]:


'''
Working script!!!!!!!!!!!!!!!!!!!!!!!
'''

import cv2
import numpy as np

def count_objects(file_path_roi, file_path_signal):
    # Read the ROI image file
    img_roi = cv2.imread(file_path_roi, cv2.IMREAD_GRAYSCALE)

    # Read the signal image file
    img_signal = cv2.imread(file_path_signal, cv2.IMREAD_GRAYSCALE)

    # Threshold the images to create binary images
    thresh_roi = cv2.threshold(img_roi, 0, 255, cv2.THRESH_BINARY)[1]
    thresh_signal = cv2.threshold(img_signal, 0, 255, cv2.THRESH_BINARY)[1]

    # Invert the binary images (to make objects white and background black)
    inverted_roi = cv2.bitwise_not(thresh_roi)
    inverted_signal = cv2.bitwise_not(thresh_signal)

    # Find contours in the inverted images
    contours_roi, hierarchy = cv2.findContours(inverted_roi, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    contours_signal, hierarchy = cv2.findContours(inverted_signal, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Count the number of ROI contours (i.e., objects) found
    roi_count = len(contours_roi)

    # Count the number of signal contours (i.e., objects) found
    signal_count = len(contours_signal)

    # Count the number of ROI contours that have at least one signal inside
    roi_with_signal_count = 0

    for roi_contour in contours_roi:
        for signal_contour in contours_signal:
            signal_point = tuple(signal_contour[0][0].astype(float))
            if cv2.pointPolygonTest(roi_contour, signal_point, False) >= 0:
                roi_with_signal_count += 1
                break

    # Count the number of ROI contours that have no signal inside
    roi_without_signal_count = roi_count - roi_with_signal_count

    return roi_count, signal_count, roi_with_signal_count, roi_without_signal_count




filepath_cells = '/Volumes/msdata/flwilfli/Lab/users/Jeremy/Nikon/GFP-Ede1-GFP+3xGBP_20h_Rapa_starvation/20hRapa/Replicate 3/cells_mask/220230303_2_20hRapa_FW_Y6612_pCUP_BFP_3xGBP_001_Simple Segmentation_v6.tiff_mask.tif'
filepath_signal = '/Volumes/msdata/flwilfli/Lab/users/Jeremy/Nikon/GFP-Ede1-GFP+3xGBP_20h_Rapa_starvation/20hRapa/Replicate 3/punctae_mask/C2-220230303_2_20hRapa_FW_Y6612_pCUP_BFP_3xGBP_001.nd2.tif_mask_try.tif'
print(filepath_cells)
for i in range(1, 31):  # Replace "11" with the maximum number you want to use
    num_str = str(i).zfill(3)  # Convert number to zero-padded string
    new_filepath_cells = filepath_cells.replace('001', num_str)  # Replace "003" with the new string
    new_filepath_signal = filepath_signal.replace('001', num_str)

    roi_image_path = new_filepath_cells
    signal_image_path = new_filepath_signal


# roi_image_path = 
# signal_image_path = 

    roi_count, signal_count, roi_with_signal_count, roi_without_signal_count = count_objects(roi_image_path, signal_image_path)
    
    '''
    print("ROI Count: ", roi_count)
    print("Signal Count: ", signal_count)
    print("ROI with Signal Count: ", roi_with_signal_count)
    print("ROI without Signal Count: ", roi_without_signal_count)
    '''    
    print(roi_count, signal_count, roi_with_signal_count, roi_without_signal_count)

#print('done')


# In[ ]:




