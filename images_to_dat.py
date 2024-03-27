import logging
from pathlib import Path
from PIL import Image
from matplotlib.cbook import to_filehandle
import numpy as np
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
            output_path = image_file.with_suffix('.npy')
            
            # Save the non-flattened full array, just as is, to the file
            np.save(output_path, image_array)
            
            logging.info("%s converted and saved as %s", image_file, output_path)
    except (FileNotFoundError, OSError) as e:
        # Handle file-related errors
        logging.error("Error processing %s: %s", image_file, e)
    except Exception as e:
        # Handle any other errors that occur during image processing
        logging.error("Unexpected error processing %s: %s", image_file, e)

def main() -> None:
    # Set up logging
    logging.basicConfig(filename='image_processing.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    try:
        # Get the current directory
        current_directory = Path(__file__).resolve().parent
        logging.info("Current Directory: %s", current_directory)
        
        # Get a list of image files in the current directory
        image_files = get_image_files_paths(current_directory)
        
        # Process images using multiprocessing for parallel processing
        with ProcessPoolExecutor() as executor:
            # Map the process_image function to each image file, processing them in parallel
            executor.map(process_image, image_files)
    except Exception as e:
        logging.error("Error in main: %s", e)

if __name__ == "__main__":
    main()
