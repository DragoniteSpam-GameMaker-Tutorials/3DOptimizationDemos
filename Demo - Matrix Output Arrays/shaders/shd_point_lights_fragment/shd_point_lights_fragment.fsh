varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

void main() {
    vec4 startingColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    float NdotL = dot(v_worldNormal, vec3(-1));
    vec3 light = vec3(max(NdotL, 0.1));
    
    gl_FragColor.rgb = startingColor.rgb * min(vec3(1), light);
    gl_FragColor.a = startingColor.a;
}