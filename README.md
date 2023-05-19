# size-upper
Shell script that scan folder for low quality photos and improves resolution by 4 times

# Requirements
### Arch
yay -S realesrgan-ncnn-vulkan libwebp

# Usage
/bash-recursive4.sh -i /path/to/folder/with/folders/of/photos

Script will scan every photo, if its resolution lower than 2000 X 2000 then it will 4x it. 
Then it will decode it in webp with 70% quality that will reduce size almost to the original.


Here some examples: 
253 x 392 - 243 KB vs 1012 x 1568 - 114 KB  
![image](https://github.com/gavr123456789/size-upper/assets/30507409/0e9566bc-4980-45d9-881b-e07fe7120ac4)

3400 x 4864 - 861 KB vs 850 x 1216 - 2200 KB  
![image](https://github.com/gavr123456789/size-upper/assets/30507409/3c9c6146-705e-465f-b4fb-709a523a73af)
