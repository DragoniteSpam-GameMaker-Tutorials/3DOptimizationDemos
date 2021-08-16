attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

#define LIGHT_COUNT 16

uniform vec3 lightPosition[LIGHT_COUNT];
uniform vec3 lightColor[LIGHT_COUNT];
uniform float lightRange[LIGHT_COUNT];

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    vec3 worldPos = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.)).xyz;
    vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    
    vec3 light = vec3(0.1);
    for (int i = 0; i < LIGHT_COUNT; i++) {
        vec3 lightDirection = normalize(lightPosition[i] - worldPos);
        float dist = length(lightPosition[i] - worldPos);
        float NdotL = dot(worldNormal, lightDirection);
        float att = max(1.0 - dist / lightRange[i], 0.0);
        light += max(lightColor[i] * NdotL * att, 0.0);
    }
    
    v_vColour = in_Colour * vec4(light, 1);
    v_vTexcoord = in_TextureCoord;
}