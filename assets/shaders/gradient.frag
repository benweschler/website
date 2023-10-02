#version 460 core

#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec2 iSize;
uniform vec4 upperLeftColor;
uniform vec4 upperRightColor;
uniform vec4 bottomLeftColor;
uniform vec4 bottomRightColor;

out vec4 fragColor;

mat2 Rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(2127.1, 81.17)), dot(p, vec2(1269.5, 283.37)));
    return fract(sin(p)*43758.5453);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = f*f*(3.0-2.0*f);

    float n = mix(mix(dot(-1.0+2.0*hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
    dot(-1.0+2.0*hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
    mix(dot(-1.0+2.0*hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
    dot(-1.0+2.0*hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
    return 0.5 + 0.5*n;
}

void main() {
    vec2 uv = FlutterFragCoord() / iSize;
    float aspectRatio = iSize.x / iSize.y;

    vec2 tuv = uv - .5;

    // rotate with Noise
    float degree = noise(vec2(iTime*.1, tuv.x*tuv.y));

    tuv.y *= 1./aspectRatio;
    tuv *= Rot(radians((degree-.5)*720.+180.));
    tuv.y *= aspectRatio;


    // Wave warp with sin
    float frequency = 5.;
    float amplitude = 30.;
    float speed = iTime * 2.;
    tuv.x += sin(tuv.y*frequency+speed)/amplitude;
    tuv.y += sin(tuv.x*frequency*1.5+speed)/(amplitude*.5);

    // draw the image
    vec4 colorYellow = vec4(.957, .737, .623, 1.);
    vec4 colorDeepBlue = vec4(.192, .384, .933, 1.);
    vec4 colorPink = vec4(.910, .510, .8, 1.);
    vec4 colorBlue = vec4(0.350, .71, .953, 1.);

    // Paint the gradient
    vec4 layer1 = mix(upperRightColor, upperLeftColor, smoothstep(-.3, .2, (tuv*Rot(radians(-5.))).x));
    vec4 layer2 = mix(bottomRightColor, bottomLeftColor, smoothstep(-.3, .2, (tuv*Rot(radians(-5.))).x));

    fragColor = mix(layer1, layer2, smoothstep(.5, -.3, tuv.y));
}
