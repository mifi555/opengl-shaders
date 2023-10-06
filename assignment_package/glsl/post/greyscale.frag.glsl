#version 330
// The UV of each vertex. This is implicitly passed to the fragment shader.
in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

void main()
{
    // TODO Homework 5
    color = vec3(0, 0, 0);

    //sample rendered texture and extract rgb values
    vec3 sceneColor = texture(u_RenderedTexture, fs_UV).rgb;

    //convert to greyscale

    //grey = 0.21 * red + 0.72 * green + 0.07 * blue
    float greyValue = 0.21 * sceneColor.r + 0.72 * sceneColor.g + 0.07 * sceneColor.b;
    vec3 greyscaleColor = vec3(greyValue);

    // Vignette effect
    //center of screen in UV coordinates is 0.5, 0.5
    vec2 center = vec2(0.5, 0.5);
    //calculate the distance from the current fragment to the center
    float dist = distance(fs_UV, center);
    //calculate max distance from center of unit square to one of its corners
    //unit square cause UV coordinates span from (0,0) to (1,1)
    //diagonal of a square is: side * sqrt(2).
    float maxDist = 1 *sqrt(2)/2.0;
    float vignette = smoothstep(0.7, 1.0, dist / maxDist);

    //multiply the greyscale color by vignette effect to darken the edges
    color = greyscaleColor * (1.0 - vignette * 0.5);
}
