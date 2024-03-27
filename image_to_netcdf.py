# load images and save data to netcdf4 file format
import os   
import numpy as np
import logging
import re
import netCDF4 as nc
from PIL import Image
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor
from typing import List

def get_image_files_paths(folder_path: str) -> List[str]:
    """
    Get a list of image files in the specified folder.

    Args:
        folder_path (str): The path to the folder containing image files.

    Returns:
        list: A list of image file paths.
    """
    try:
        folder_path = Path(folder_path)
        # Filter out only the image files based on their extensions
        image_files = [file for file in folder_path.iterdir() if file.suffix.lower() in ('.jpg', '.jpeg', '.png', '.gif', '.bmp')]
        return [str(image_file) for image_file in image_files]
    except OSError as e:
        logging.error(f"Error in get_image_files_paths: {e}")
        return []
    
def process_image(image_file: str) -> None:
    """
    Process each image file: open, convert to a 3D NumPy array, and save as a file.

    Args:
        image_file (str): The name of the image file to process.
    """
    try:
        image_file = Path(image_file)
        # Construct the full path to the image file
        logging.info("Processing: %s", image_file)
        
        # Open the image
        with Image.open(image_file) as image:
            # Convert the image to a 3D NumPy array
            image_array = np.array(image)
            logging.debug("Array Shape: %s", image_array.shape)          

            # Construct the output file paths
            output_path = image_file.with_suffix('.nc')

            # Save the non-flattened full array, just as is, to the ncffile
            with nc.Dataset(output_path, 'w', format='NETCDF4') as dataset:
                for dim, size in enumerate(image_array.shape):
                    dataset.createDimension(f'dim{dim}', size)
                dataset.createVariable('image', 'f4', tuple(f'dim{dim}' for dim in range(len(image_array.shape))), zlib=True, complevel=9)
                dataset['image'][:] = image_array

            logging.info("%s converted and saved as %s", image_file, output_path)
    except (FileNotFoundError, OSError) as e:
        # Handle file-related errors
        logging.error("Error processing %s: %s", image_file, e)
    except Exception as e:
        # Handle any other errors that occur during image processing
        logging.error("Unexpected error processing %s: %s", image_file, e)

def main() -> None:
    # Set up logging
    logging.basicConfig(filename='image_processing.log', level=logging.INFO)

    try:
        # Get a list of image files in the specified folder
        image_files = get_image_files_paths("./")
        # Process the image files in parallel
        with ProcessPoolExecutor() as executor:
            executor.map(process_image, image_files)
    except Exception as e:
        # Handle any other errors that occur during image processing
        logging.error("Unexpected error in main: %s", e)
            
if __name__ == '__main__':
    main()
    
    
# Path: images_to_netcdf.py
# Compare this snippet from read_dat.py:
#   Returns:
#         list: A list of .dat file paths.
#     """
#     try:
#         # List all files in the folder
#         all_files = os.listdir(folder_path)
#         # Filter out only the .dat files based on their extensions
#         dat_files = [file for file in all_files if file.lower().endswith('.npy')]
#         return [os.path.join(folder_path, dat_file) for dat_file in dat_files]
#     except Exception as e:
#         logging.error(f"Error in get_dat_files_paths: {e}")
#         return []
#