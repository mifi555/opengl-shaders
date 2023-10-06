#version 330

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

//To compute a Sobel filter, you need two kernels:

//one for computing the horizontal gradient:
const mat3 sobelHorizontal = mat3(
    3.0,  0.0, -3.0,
    10.0, 0.0, -10.0,
    3.0,  0.0, -3.0
);

//one for computing the vertical gradient:
const mat3 sobelVertical = mat3(
    3.0,  10.0, 3.0,
    0.0,  0.0,  0.0,
    -3.0, -10.0, -3.0
);

void main()
{
    // TODO Homework 5
    color = vec3(0, 0, 0);

    //Sobel filter effectively does is compute the approximate gradient (i.e. slope) of the color at each pixel,
    //and where the color abruptly changes it returns a high value, otherwise it returns roughly black, or a slope of zero.
    //size of one pixel in UV space
    vec2 pixelSizeInUVSpace = 1.0 / vec2(u_Dimensions);
    vec3 gradientX = vec3(0.0);
    vec3 gradientY = vec3(0.0);

    //for each pixel, sample neighbours (3x3)
    for(int y = -1; y <= 1; y++) {
        for(int x = -1; x <= 1; x++) {
            vec2 offset = vec2(x, y) * pixelSizeInUVSpace;
            vec3 sampledColor = texture(u_RenderedTexture, fs_UV + offset).rgb;

            //apply sobel weights

            //index by row (y coord) then column (x coord)
            gradientX += sampledColor * sobelHorizontal[y+1][x+1];
            gradientY += sampledColor * sobelVertical[y+1][x+1];
        }
    }
    //Once you have your horizontal and vertical color gradients,
    //square them, sum them, and set the output of your shader to the square root that that sum.
    vec3 gradientMagnitude = sqrt(gradientX * gradientX + gradientY * gradientY);

    //set color to gradient's magnitude
    color = gradientMagnitude;
}
