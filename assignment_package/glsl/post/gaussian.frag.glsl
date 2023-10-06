#version 330

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

//**added**
//11x11 Gaussian kernel
const float kernel[121] = float[](0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.00799, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849, 0.007239, 0.007653, 0.00799, 0.00824, 0.008394, 0.008446, 0.008394, 0.00824, 0.00799, 0.007653, 0.007239, 0.007559, 0.00799, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.00799, 0.007559, 0.007795, 0.00824, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.00824, 0.007795, 0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941, 0.00799, 0.008446, 0.008819, 0.009095, 0.009265, 0.009322, 0.009265, 0.009095, 0.008819, 0.008446, 0.00799, 0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941, 0.007795, 0.00824, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.00824, 0.007795, 0.007559, 0.00799, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.00799, 0.007559, 0.007239, 0.007653, 0.00799, 0.00824, 0.008394, 0.008446, 0.008394, 0.00824, 0.00799, 0.007653, 0.007239, 0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.00799, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849);

void main()
{
    // TODO Homework 5

    color = vec3(0, 0, 0);

    //**added**

    //accumulate sum of blurred colors
    vec3 gaussianBlur = vec3(0.0);
    //size of one pixel in UV space
    vec2 pixelSizeInUVSpace = 1.0 / vec2(u_Dimensions);

    //iterate through an 11x11
    //we sample 5 pixels in every direction
    for(int y = -5; y <= 5; y++) {
        for(int x = -5; x <= 5; x++) {
            //UV offset: offset in UV coordinates to current neighboring pixel relative to the central pixel
            vec2 offset = pixelSizeInUVSpace * vec2(x, y);

            //sample color at offset
            color = texture(u_RenderedTexture, fs_UV + offset).rgb;

            // Multiply the sample by the corresponding kernel value at that location.
            // take each pixel in the image, and set its value to a weighted average of its surrounding pixels, where the weights come from the Gaussian kernel.
            //11 accounts for the width of the kernel, allowing us to "skip" whole rows in the 1D array based on our y-coordinate. The x + 5 then lets us select the specific value within that "row".
            gaussianBlur += color * kernel[(y + 5) * 11 + (x + 5)];
        }
    }

    color = gaussianBlur;
}
