void rgb_to_hsv(vec4 rgb, out vec4 outcol)
{
  float cmax, cmin, h, s, v, cdelta;
  vec3 c;

  cmax = max(rgb[0], max(rgb[1], rgb[2]));
  cmin = min(rgb[0], min(rgb[1], rgb[2]));
  cdelta = cmax - cmin;

  v = cmax;
  if (cmax != 0.0) {
    s = cdelta / cmax;
  }
  else {
    s = 0.0;
    h = 0.0;
  }

  if (s == 0.0) {
    h = 0.0;
  }
  else {
    c = (vec3(cmax) - rgb.xyz) / cdelta;

    if (rgb.x == cmax) {
      h = c[2] - c[1];
    }
    else if (rgb.y == cmax) {
      h = 2.0 + c[0] - c[2];
    }
    else {
      h = 4.0 + c[1] - c[0];
    }

    h /= 6.0;

    if (h < 0.0) {
      h += 1.0;
    }
  }

  outcol = vec4(h, s, v, rgb.w);
}

void hsv_to_rgb(vec4 hsv, out vec4 outcol)
{
  float i, f, p, q, t, h, s, v;
  vec3 rgb;

  h = hsv[0];
  s = hsv[1];
  v = hsv[2];

  if (s == 0.0) {
    rgb = vec3(v, v, v);
  }
  else {
    if (h == 1.0) {
      h = 0.0;
    }

    h *= 6.0;
    i = floor(h);
    f = h - i;
    rgb = vec3(f, f, f);
    p = v * (1.0 - s);
    q = v * (1.0 - (s * f));
    t = v * (1.0 - (s * (1.0 - f)));

    if (i == 0.0) {
      rgb = vec3(v, t, p);
    }
    else if (i == 1.0) {
      rgb = vec3(q, v, p);
    }
    else if (i == 2.0) {
      rgb = vec3(p, v, t);
    }
    else if (i == 3.0) {
      rgb = vec3(p, q, v);
    }
    else if (i == 4.0) {
      rgb = vec3(t, p, v);
    }
    else {
      rgb = vec3(v, p, q);
    }
  }

  outcol = vec4(rgb, hsv.w);
}

void color_alpha_clear(vec4 color, out vec4 result)
{
  result = vec4(color.rgb, 1.0);
}

void color_alpha_premultiply(vec4 color, out vec4 result)
{
  result = vec4(color.rgb * color.a, color.a);
}

void color_alpha_unpremultiply(vec4 color, out vec4 result)
{
  if (color.a == 0.0 || color.a == 1.0) {
    result = color;
  }
  else {
    result = vec4(color.rgb / color.a, color.a);
  }
}

float linear_rgb_to_srgb(float color)
{
  if (color < 0.0031308) {
    return (color < 0.0) ? 0.0 : color * 12.92;
  }

  return 1.055 * pow(color, 1.0 / 2.4) - 0.055;
}

vec3 linear_rgb_to_srgb(vec3 color)
{
  return vec3(
      linear_rgb_to_srgb(color.r), linear_rgb_to_srgb(color.g), linear_rgb_to_srgb(color.b));
}

float srgb_to_linear_rgb(float color)
{
  if (color < 0.04045) {
    return (color < 0.0) ? 0.0 : color * (1.0 / 12.92);
  }

  return pow((color + 0.055) * (1.0 / 1.055), 2.4);
}

vec3 srgb_to_linear_rgb(vec3 color)
{
  return vec3(
      srgb_to_linear_rgb(color.r), srgb_to_linear_rgb(color.g), srgb_to_linear_rgb(color.b));
}

float get_luminance(vec3 color, vec3 luminance_coefficients)
{
  return dot(color, luminance_coefficients);
}