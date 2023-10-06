#version 330

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

//function to calculate the Voronoi centerpoint
vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)),
                 dot(p, vec2(269.5,183.3))))
                 * 43758.5453);
}

//worley noise function
float worleyNoise(vec2 uv) {
    uv *= 10.0; // Now the space is 10x10 instead of 1x1. Change this to any number you want.
    vec2 uvInt = floor(uv);
    vec2 uvFract = fract(uv);
    float minDist = 1.0; // Minimum distance initialized to max.
    for(int y = -1; y <= 1; ++y) {
        for(int x = -1; x <= 1; ++x) {
            vec2 neighbor = vec2(float(x), float(y)); // Direction in which neighbor cell lies
            vec2 point = random2(uvInt + neighbor); // Get the Voronoi centerpoint for the neighboring cell
            vec2 diff = neighbor + point - uvFract; // Distance between fragment coord and neighbor’s Voronoi point
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

void main()
{
    // TODO Homework 5
    color = vec3(0, 0, 0);

    //calculate the noise value
    float noiseR = worleyNoise(fs_UV + vec2(u_Time * 0.01));
    float noiseG = worleyNoise(fs_UV + vec2(u_Time * 0.01 + 5.0));
    float noiseB = worleyNoise(fs_UV + vec2(u_Time * 0.01 + 10.0));

    //use the noise value to shift the UVs differently for each channel
    vec2 offsetR = vec2(noiseR * 0.02, 0.0);  //R shifted horizontally
    vec2 offsetG = vec2(0.0, noiseG * 0.02);  //G shifted vertically
    vec2 offsetB = vec2(-noiseB * 0.02, -noiseB * 0.02);  //B shifted both horizontally & vertically

    //sample the original texture with the offset UVs
    float red = texture(u_RenderedTexture, fs_UV + offsetR).r;
    float green = texture(u_RenderedTexture, fs_UV + offsetG).g;
    float blue = texture(u_RenderedTexture, fs_UV + offsetB).b;

    color = vec3(red, green, blue);
}
