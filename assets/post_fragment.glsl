#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_texture;
uniform float u_deltaTime;
uniform float u_scaleFactor;

varying vec4 v_color;
varying vec2 v_texCoords;

float pseudoRand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 squeeze(float value, float min) {
  return vec4(vec3((value * min) + (1.0 - min)), 1.0);
}

vec4 bloomFilter(sampler2D texture, vec2 coordinates, float glowSize) {
  vec4 color = texture2D(texture, coordinates);
  vec4 sum = vec4(0);
  vec4 bloom = vec4(0);
  for(int i= -4 ;i < 4; i++) {
    for (int j = -3; j < 3; j++) {
      sum += texture2D(texture, coordinates + vec2(j, i) * 0.004) * glowSize;
    }
  }
  if (color.r < 0.3) {
    bloom = sum * sum * 0.012 + color;
  } else {
    if (color.r < 0.5) {
      bloom = sum * sum * 0.009 + color;
    } else {
      bloom = sum * sum * 0.0075 + color;
    }
  }
  return bloom;
}

void main() {
  vec4 color = texture2D(u_texture, v_texCoords);

  /*
   * BLOOM FILTER
   */

  vec4 bloom = bloomFilter(u_texture, v_texCoords, 0.16);

  /*
   * GRADIENT
   */

  vec2 pixel = gl_FragCoord.xy;
  float grey = 1.0;
  grey += ((mod(pixel.x, u_scaleFactor) + mod(pixel.y, u_scaleFactor)) / 8.0);
  vec4 gradient = squeeze(grey, 0.8);

  /*
   * NOISE
   */

  vec4 noise = squeeze(pseudoRand(v_texCoords * u_deltaTime * 1000.0), 0.3);

  // gl_FragColor = bloom * gradient * noise;
  gl_FragColor = color * gradient * noise;
}
