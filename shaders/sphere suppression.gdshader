shader_type canvas_item;


uniform vec3 backFillColour : source_color = vec3(0.80,0.60,1.00);
uniform vec3 frontFillInnerColour : source_color = vec3(0.35,0.00,1.00);
uniform vec3 frontFillOuterColour : source_color = vec3(0.50,0.25,1.00);
uniform vec3 ringColour : source_color = vec3(0.17,0.00,0.34);
uniform vec3 fresnelColour : source_color = vec3(0.8,0.75,1.00);
uniform vec3 innerRingGlowColour : source_color = vec3(0.20,0.00,0.60);

uniform vec4 fillcolour : source_color = vec4(1);
uniform float ringWidth = 0.15;
uniform float innerCircleRadiusOffset = 0.0;
uniform float fill_value : hint_range(-1, 1) = -1.0;
uniform float seed : hint_range(-10, 10) = 0.0;



float sdArc(in vec2 p, in vec2 sc, in float ra, float rb)
{
    p.x = abs(p.x);
    return ((sc.y*p.x>sc.x*p.y) ? length(p-sc*ra) :
                                  abs(length(p)-ra)) - rb;
}

mat2 Get2DRotationMatrix(float angle) {
    float c = cos(angle);
    float s = sin(angle);
	vec2 V1 = vec2(c, -s);
	vec2 V2 = vec2(s, c);
    return mat2(V1,V2);
}

void fragment() {
	vec2 uv = ((UV / -0.48)) + vec2(1.038,1.038);
    vec2 normalizedCenteredUV = (uv - 0.5) * 2.0;
    float circleSDF = length(uv);
    float oneMinusRingWidth = 1.0 - ringWidth;

    float circleA = step(circleSDF, 1.0);
    float circleB = step(circleSDF, oneMinusRingWidth);
    float ring = circleA - circleB;
    float fillMaskCircle = step(circleSDF, oneMinusRingWidth - innerCircleRadiusOffset);

    float ringGlowCircleSDF = circleSDF - 1.0;
    const float innerRingGlowRadiusOffset = 0.15;

    float innerRingGlow = ringGlowCircleSDF + innerRingGlowRadiusOffset;
    float outerRingGlow = ringGlowCircleSDF;

    const float outerRingGlowWidth = 0.01;
    float outerRingGlowPower = 0.8;

    const float innerRingGlowWidth = 0.01;
    const float innerRingGlowPower = 1.2;

    const float outerRingGlowAnimation = 12.0;
    const float outerRingGlowAnimationRange = 0.2;

    innerRingGlow = pow(innerRingGlowWidth / innerRingGlow, innerRingGlowPower);
    innerRingGlow = clamp(innerRingGlow - fillMaskCircle, 0.0, 1.0);

    outerRingGlowPower += (sin(TIME * outerRingGlowAnimation) * outerRingGlowAnimationRange);

    outerRingGlow = pow(outerRingGlowWidth / outerRingGlow, outerRingGlowPower);
    outerRingGlow = clamp(outerRingGlow - fillMaskCircle, 0.0, 1.0);

    const float fillAnimationFrequency = 4.0;
    const float fillAnimationAmplitude = 0.05;

    float fillAnimationPhase = TIME * fillAnimationFrequency;

    float fillAnimation = sin(fillAnimationPhase) * fillAnimationAmplitude;

    const float waveFrequency = 2.0;
    const float waveAmplitude = 0.05;

    const float waveAnimation = 2.0;

    float frontWavePhase = ((TIME + seed) * waveAnimation) + uv.x;
    float backWavePhase = ((TIME + seed) * -waveAnimation) + uv.x;

    frontWavePhase *= waveFrequency;
    backWavePhase *= waveFrequency;

    const float backWavesPhaseOffset = PI;

    float frontWaves = sin(frontWavePhase) * waveAmplitude;
    float backWaves = sin(backWavePhase + backWavesPhaseOffset) * waveAmplitude;

    float verticalBand = sin(uv.x + (PI * 0.5)) - 0.3;
    verticalBand = smoothstep(0.1, 0.9, verticalBand);

    const float animatedVerticalBandStrength = 0.125;
    float animatedVerticalBand = verticalBand * animatedVerticalBandStrength;

    animatedVerticalBand *= sin(TIME * fillAnimationFrequency);

    frontWaves += animatedVerticalBand;
    backWaves -= animatedVerticalBand;

    fillAnimation *= verticalBand;

    float fillProgressAnimationFrequency = 1.0;
    float fillProgressAnimationAmplitude = 0.1;

    float fillProgress = fill_value;

    fillProgress += sin((TIME * fillProgressAnimationFrequency) * PI) * fillProgressAnimationAmplitude;

    float frontFill = step(uv.y, (fillAnimation + frontWaves) + fillProgress);
    float backFill = step(uv.y, (-fillAnimation + backWaves) + fillProgress);

    frontFill *= fillMaskCircle;
    backFill *= fillMaskCircle;

    backFill = clamp(backFill - frontFill, 0.0, 1.0);

    float fillMask = 1.0 - (frontFill + backFill);
    fillMask *= fillMaskCircle;

    float fill = frontFill + backFill;

    const float fresnelOffset = 0.01;
    float fresnel = (circleSDF + fresnelOffset) * fillMask;

    const float fresnelPower = 5.0;
    fresnel = clamp(pow(fresnel, fresnelPower), 0.0, 1.0);

    const float frontFillFresnelPower = 5.0;
    const float frontFillFresnelOffset = 0.02;

    float frontFillFresnel = (circleSDF + frontFillFresnelOffset) * (1.0 - fillMask);
    frontFillFresnel = clamp(pow(frontFillFresnel, frontFillFresnelPower), 0.0, 1.0);

    float specularArcAngle1 = radians(15.0);
    float specularArcAngle2 = radians(2.0);

    float specularArcRotation1 = radians(60.0);
    float specularArcRotation2 = radians(28.0);

    vec2 specularArcSC1 = vec2(sin(specularArcAngle1), cos(specularArcAngle1));
    vec2 specularArcSC2 = vec2(sin(specularArcAngle2), cos(specularArcAngle2));

    const float specularArcOffset = 0.35;
    const float specularArcWidth = 0.07;

    vec2 specularArcUV1 = Get2DRotationMatrix(specularArcRotation1) * uv;
    vec2 specularArcUV2 = Get2DRotationMatrix(specularArcRotation2) * uv;

    float specularArc1 = sdArc(specularArcUV1, specularArcSC1, 1.0 - specularArcOffset, specularArcWidth);
    float specularArc2 = sdArc(specularArcUV2, specularArcSC2, 1.0 - specularArcOffset, specularArcWidth);

    specularArc1 = step(specularArc1, 0.0);
    specularArc2 = step(specularArc2, 0.0);

    const float specularStrength = 0.2;
    float specular = specularArc1 + specularArc2;

    specular *= specularStrength;

    float mask = ring + fill + fresnel + specular;

    vec3 frontFillColour = mix(frontFillInnerColour, frontFillOuterColour, frontFillFresnel);

    const vec3 specularColour = vec3(1.0, 1.0, 0.9);
    const vec3 outerRingGlowColour = vec3(1.0, 0.8, 0.1);//外环发光颜色

    vec3 rgb =

        (ring * ringColour) +

        (innerRingGlow * innerRingGlowColour) +
        (outerRingGlow * outerRingGlowColour) +


        ((frontFill * frontFillColour) +
        (backFill * backFillColour))*fillcolour.rbg +
        (fresnel * fresnelColour) +
        (specular * specularColour);


    const float backgroundGradientPower = 0.6;

    float backgroundGradient = length(normalizedCenteredUV);

    backgroundGradient = pow(backgroundGradient, backgroundGradientPower);
    backgroundGradient = smoothstep(0.0, 1.0, backgroundGradient);//第一个参数是背景阴影的亮度

    vec3 backgroundGradientInnerColour = vec3(0.13, 0.0, 0.4);
    vec3 backgroundGradientOuterColour = vec3(0.0, 0.0, 0.0);//背景外玻璃颜色

    vec3 background = mix(backgroundGradientInnerColour, backgroundGradientOuterColour, backgroundGradient);

    background = clamp(background - (fill + ring), 0.0, 1.0);//背景-（填充+环）,亮度参数1,亮度参数2

    const float backgroundStrength = 0.65;//背景强度
    background *= backgroundStrength;

    rgb += background;

	COLOR = vec4(rgb, mask);
}