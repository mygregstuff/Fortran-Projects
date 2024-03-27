import os
import numpy as np
import logging
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
        List[str]: A list of image file paths.
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
            output_path = image_file.with_suffix('.txt')
            output_path_shape = image_file.with_suffix('.shape.txt')

            # Save the non-flattened full array, just as is, to a text file
            np.savetxt(output_path, image_array.flatten(), fmt='%d')
            np.savetxt(output_path_shape, image_array.shape, fmt='%d')

            # Log successful conversion and save
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
