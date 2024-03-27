# read .dat files into numpy arrays in the current folder
import os   
import numpy as np
import logging
import re
import matplotlib.pyplot as plt
from PIL import Image

def get_dat_files_paths(folder_path):
    """
    Get a list of .dat files in the specified folder.

    Args:
        folder_path (str): The path to the folder containing .dat files.

    Returns:
        list: A list of .dat file paths.
    """
    try:
        # List all files in the folder
        all_files = os.listdir(folder_path)
        # Filter out only the .dat files based on their extensions
        dat_files = [file for file in all_files if file.lower().endswith('.npy')]
        return [os.path.join(folder_path, dat_file) for dat_file in dat_files]
    except Exception as e:
        logging.error(f"Error in get_dat_files_paths: {e}") 
        return []

def process_dat(dat_file):
    """
    Process each .dat file: open, convert to a 3D NumPy array, and save as a .png file.

    Args:
        dat_file (str): The name of the .dat file to process.
    """
    try:
        # Construct the full path to the .dat file
        logging.info("Processing: %s", dat_file)
        
        # Open the .dat file
        with open(dat_file, 'rb') as file:
            # Read the .dat file into a NumPy array
            dat_array= np.fromfile(file)
            logging.debug("Array Shape: %s", dat_array.shape)          
            
            # Get the dimensions of the image
            
            # Convert the 1D array to a 3D array
            image_array = dat_array
            print(image_array.shape)
            logging.debug("Array Shape: %s", image_array.shape)          
        
    except Exception as e:
        # Handle any errors that occur during .dat file processing
        logging.error("Error processing %s: %s", dat_file, e)
        
def main():
    # Set up logging
    logging.basicConfig(filename='dat_processing.log', level=logging.INFO)

    try:
        # Get a list of .dat files in the specified folder
        dat_files = get_dat_files_paths("./")
        logging.info("Found %s .dat files", len(dat_files))
        
        # Process each .dat file
        for dat_file in dat_files:
            process_dat(dat_file)
    except Exception as e:
        # Handle any errors that occur during the main process
        logging.error("Error in main: %s", e)

if __name__ == '__main__':
    main()
    
# The get_dat_files_paths function is similar to the get_image_files_paths function, but it filters out only the .dat files based on their extensions. The process_dat function is similar to the process_image function, but it reads the .dat file into a 1D NumPy array, reshapes it to a 3D array, and saves it as a .png file. The main function is similar to the main function in images_to_dat.py, but it processes .dat files instead of image files. The main function gets a list of .dat files in the specified folder, and then processes each .dat file. The main function is called when the script is run as the main program. The script can be run from the command line using the following command:
