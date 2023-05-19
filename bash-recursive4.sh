#!/bin/bash

# Define the directory containing the images
# image_dir="/home/gavr/scale/origin"

# Parse command line arguments
while getopts "i:" opt; do
  case ${opt} in
    i )
      image_dir=${OPTARG}
      ;;
    \? )
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
    : )
      echo "Option -${OPTARG} requires an argument." >&2
      exit 1
      ;;
  esac
done

# Define the directory for small images
small_dir_name="smalls"
scaled_dir_name="scaled"

# Loop through each subdirectory in the image directory
for dir in "${image_dir}"/*/; do
    # Get the directory name without the trailing "/"
    dir=${dir%*/}
    # Define the directory for small images
    small_dir="${dir}/smalls"
    scaled_dir="${dir}/scaled"
    rm -rf "${small_dir}"
    rm -rf "${scaled_dir}"
    mkdir "${small_dir}"
    mkdir "${scaled_dir}"
    # Loop through each image in the directory
    count=0 # initialize the count variable
    total=$(ls "${dir}" | wc -l) # count the total number of images
    for image in "${dir}"/*.{png,jpg,jpeg,webp}; do
        # Get the image resolution using ImageMagick's identify command
        resolution=$(identify -format "%wx%h" "${image}")
        # Print the status message for the image
        echo "Checking ${image} (resolution: ${resolution})..."
        # Extract the width and height of the image
        width=$(echo "${resolution}" | cut -d 'x' -f 1)
        height=$(echo "${resolution}" | cut -d 'x' -f 2)
        # Check if the resolution is less than 1080p (1920x1080)
        if [ "${width}" -lt 2000 ] && [ "${height}" -lt 2000 ]; then
            # Move the image to the small directory
            mv "${image}" "${small_dir}"
            count=$((count+1)) # increment the count variable
            # Print the status message for the moved image
            echo "Moved ${count}/${total} images to ${small_dir}"
        else
            # Print the status message for the non-moved image
            echo "${image} is already 1080p or higher"
        fi
    done

    # Check if the small directory is not empty before running the image scaling script
    if [ "$(ls -A "${small_dir}")" ]; then
        realesrgan-ncnn-vulkan -i "${small_dir}" -o "${scaled_dir}" -f webp -j 10:14:10
        for file in ${scaled_dir}/*; do cwebp -mt -q 70 "$file" -o "${file%.*}.webp"; done
        cp "${scaled_dir}"/* "${dir}"
    else
        echo "No images to scale in ${small_dir}"
    fi

    rm -rf ${scaled_dir}
    rm -rf ${small_dir}
done

