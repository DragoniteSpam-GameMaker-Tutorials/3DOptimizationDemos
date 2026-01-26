varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 lightPosition;
uniform vec3 lightDirection;
uniform vec4 lightColor;
uniform float lightRange;
uniform float lightCutoffAngle;

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

void main() {
    vec4 starting_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (starting_color.a < 0.1) discard;
    
    vec4 lightAmbient = vec4(0.5);
    vec3 lightIncoming = normalize(vec3(-1));
    float NdotL = max(dot(v_worldNormal, lightIncoming), 0.);
    
    vec4 final_color = starting_color * vec4(min(lightAmbient + lightColor * NdotL, vec4(1.)).rgb, starting_color.a);
    gl_FragColor = final_color;
}