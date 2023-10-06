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
    float luminance;

    //get color of pixel from texture
    vec3 currentColor = texture(u_RenderedTexture, fs_UV).rgb;
    vec3 bloom = vec3(0.0);
    //size of one pixel in UV space (texture coordinates)
    vec2 pixelSizeInUVSpace = 1.0 / vec2(u_Dimensions);

    //loop over 11 x 11 grid
    for(int y = -5; y <= 5; y++) {
        for(int x = -5; x <= 5; x++) {
            //offset in UV coordinates: how far we're looking from current pixel
            vec2 offset = vec2(x, y) * pixelSizeInUVSpace;
            //get neighboring pixel's color
            vec3 neighborPixelColor = texture(u_RenderedTexture, fs_UV + offset).rgb;

            // Only consider the sample if its luminance is above the threshold
            luminance = dot(neighborPixelColor, vec3(0.2126, 0.7152, 0.0722));
            if (luminance > 0.4) {
                //weighted average achieved using kernel
                bloom += neighborPixelColor * kernel[(y + 5) * 11 + (x + 5)];
            }
        }
    }

    color = currentColor + bloom;

}
