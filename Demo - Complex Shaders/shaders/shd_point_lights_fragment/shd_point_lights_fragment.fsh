#define LIGHT_COUNT 16

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 lightPosition[LIGHT_COUNT];
uniform vec3 lightColor[LIGHT_COUNT];
uniform float lightRange[LIGHT_COUNT];

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

void main() {
    vec4 startingColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    vec3 light = vec3(0.4);
    for (int i = 0; i < LIGHT_COUNT; i++) {
        vec3 lightDirection = normalize(lightPosition[i] - v_worldPosition);
        float dist = length(lightPosition[i] - v_worldPosition);
        float NdotL = dot(v_worldNormal, lightDirection);
        float att = max(1.0 - dist / lightRange[i], 0.0);
        light += max(lightColor[i] * NdotL * att, 0.0);
    }
    
    gl_FragColor.rgb = startingColor.rgb * min(vec3(1), light);
    gl_FragColor.a = startingColor.a;
}