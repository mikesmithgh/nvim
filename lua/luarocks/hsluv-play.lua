local hsluv = require('luarocks.hsluv')

local function with_hsluv(hex)
  local hsluv_color = hsluv.hex_to_hsluv(hex)

  local hue = hsluv_color[1]
  local saturation = hsluv_color[2]
  local lightness = hsluv_color[3]

  -- vim.pretty_print(hsluv_color)
  local modifier = ''

  if lightness < 20 then
    modifier = modifier .. 'dark '
    return modifier
  end
  if lightness > 80 then
    modifier = modifier .. 'light '
    return modifier
  end
  if saturation < 25 then
    modifier = modifier .. 'gray '
    return modifier
  end

  if hue < 30 then
    return modifier .. 'red'
  elseif hue < 90 then
    return modifier .. 'yellow'
  elseif hue < 150 then
    return modifier .. 'green'
  elseif hue < 210 then
    return modifier .. 'cyan'
  elseif hue < 270 then
    return modifier .. 'blue'
  elseif hue < 330 then
    return modifier .. 'magenta'
  end
  return modifier .. 'dunno'
end

local colors = {
  { 'name', 'hex', 'r', 'g', 'b' },
  { 'lightpink', '#FFB6C1', 255, 182, 193 },
  { 'pink', '#FFC0CB', 255, 192, 203 },
  { 'crimson', '#DC143C', 220, 20, 60 },
  { 'lavenderblush', '#FFF0F5', 255, 240, 245 },
  { 'palevioletred', '#DB7093', 219, 112, 147 },
  { 'hotpink', '#FF69B4', 255, 105, 180 },
  { 'deeppink', '#FF1493', 255, 20, 147 },
  { 'mediumvioletred', '#C71585', 199, 21, 133 },
  { 'orchid', '#DA70D6', 218, 112, 214 },
  { 'thistle', '#D8BFD8', 216, 191, 216 },
  { 'plum', '#DDA0DD', 221, 160, 221 },
  { 'violet', '#EE82EE', 238, 130, 238 },
  { 'fuchsia*', '#FF00FF', 255, 0, 255 },
  { 'fuchsia*', '#FF00FF', 255, 0, 255 },
  { 'darkmagenta', '#8B008B', 139, 0, 139 },
  { 'purple*', '#800080', 128, 0, 128 },
  { 'mediumorchid', '#BA55D3', 186, 85, 211 },
  { 'darkviolet', '#9400D3', 148, 0, 211 },
  { 'darkorchid', '#9932CC', 153, 50, 204 },
  { 'indigo', '#4B0082', 75, 0, 130 },
  { 'blueviolet', '#8A2BE2', 138, 43, 226 },
  { 'mediumpurple', '#9370DB', 147, 112, 219 },
  { 'mediumslateblue', '#7B68EE', 123, 104, 238 },
  { 'slateblue', '#6A5ACD', 106, 90, 205 },
  { 'darkslateblue', '#483D8B', 72, 61, 139 },
  { 'ghostwhite', '#F8F8FF', 248, 248, 255 },
  { 'lavender', '#E6E6FA', 230, 230, 250 },
  { 'blue*', '#0000FF', 0, 0, 255 },
  { 'mediumblue', '#0000CD', 0, 0, 205 },
  { 'darkblue', '#00008B', 0, 0, 139 },
  { 'navy*', '#000080', 0, 0, 128 },
  { 'midnightblue', '#191970', 25, 25, 112 },
  { 'royalblue', '#4169E1', 65, 105, 225 },
  { 'cornflowerblue', '#6495ED', 100, 149, 237 },
  { 'lightsteelblue', '#B0C4DE', 176, 196, 222 },
  { 'lightslategray', '#778899', 119, 136, 153 },
  { 'slategray', '#708090', 112, 128, 144 },
  { 'dodgerblue', '#1E90FF', 30, 144, 255 },
  { 'aliceblue', '#F0F8FF', 240, 248, 255 },
  { 'steelblue', '#4682B4', 70, 130, 180 },
  { 'lightskyblue', '#87CEFA', 135, 206, 250 },
  { 'skyblue', '#87CEEB', 135, 206, 235 },
  { 'deepskyblue', '#00BFFF', 0, 191, 255 },
  { 'lightblue', '#ADD8E6', 173, 216, 230 },
  { 'powderblue', '#B0E0E6', 176, 224, 230 },
  { 'cadetblue', '#5F9EA0', 95, 158, 160 },
  { 'darkturquoise', '#00CED1', 0, 206, 209 },
  { 'azure', '#F0FFFF', 240, 255, 255 },
  { 'lightcyan', '#E0FFFF', 224, 255, 255 },
  { 'paleturquoise', '#AFEEEE', 175, 238, 238 },
  { 'aqua*', '#00FFFF', 0, 255, 255 },
  { 'aqua*', '#00FFFF', 0, 255, 255 },
  { 'darkcyan', '#008B8B', 0, 139, 139 },
  { 'teal*', '#008080', 0, 128, 128 },
  { 'darkslategray', '#2F4F4F', 47, 79, 79 },
  { 'mediumturquoise', '#48D1CC', 72, 209, 204 },
  { 'lightseagreen', '#20B2AA', 32, 178, 170 },
  { 'turquoise', '#40E0D0', 64, 224, 208 },
  { 'aquamarine', '#7FFFD4', 127, 255, 212 },
  { 'mediumaquamarine', '#66CDAA', 102, 205, 170 },
  { 'mediumspringgreen', '#00FA9A', 0, 250, 154 },
  { 'mintcream', '#F5FFFA', 245, 255, 250 },
  { 'springgreen', '#00FF7F', 0, 255, 127 },
  { 'mediumseagreen', '#3CB371', 60, 179, 113 },
  { 'seagreen', '#2E8B57', 46, 139, 87 },
  { 'honeydew', '#F0FFF0', 240, 255, 240 },
  { 'darkseagreen', '#8FBC8F', 143, 188, 143 },
  { 'palegreen', '#98FB98', 152, 251, 152 },
  { 'lightgreen', '#90EE90', 144, 238, 144 },
  { 'limegreen', '#32CD32', 50, 205, 50 },
  { 'lime*', '#00FF00', 0, 255, 0 },
  { 'forestgreen', '#228B22', 34, 139, 34 },
  { 'green*', '#008000', 0, 128, 0 },
  { 'darkgreen', '#006400', 0, 100, 0 },
  { 'lawngreen', '#7CFC00', 124, 252, 0 },
  { 'chartreuse', '#7FFF00', 127, 255, 0 },
  { 'greenyellow', '#ADFF2F', 173, 255, 47 },
  { 'darkolivegreen', '#556B2F', 85, 107, 47 },
  { 'yellowgreen', '#9ACD32', 154, 205, 50 },
  { 'olivedrab', '#6B8E23', 107, 142, 35 },
  { 'ivory', '#FFFFF0', 255, 255, 240 },
  { 'beige', '#F5F5DC', 245, 245, 220 },
  { 'lightyellow', '#FFFFE0', 255, 255, 224 },
  { 'lightgoldenrodyellow', '#FAFAD2', 250, 250, 210 },
  { 'yellow*', '#FFFF00', 255, 255, 0 },
  { 'olive*', '#808000', 128, 128, 0 },
  { 'darkkhaki', '#BDB76B', 189, 183, 107 },
  { 'palegoldenrod', '#EEE8AA', 238, 232, 170 },
  { 'lemonchiffon', '#FFFACD', 255, 250, 205 },
  { 'khaki', '#F0E68C', 240, 230, 140 },
  { 'gold', '#FFD700', 255, 215, 0 },
  { 'cornsilk', '#FFF8DC', 255, 248, 220 },
  { 'goldenrod', '#DAA520', 218, 165, 32 },
  { 'darkgoldenrod', '#B8860B', 184, 134, 11 },
  { 'floralwhite', '#FFFAF0', 255, 250, 240 },
  { 'oldlace', '#FDF5E6', 253, 245, 230 },
  { 'wheat', '#F5DEB3', 245, 222, 179 },
  { 'orange*', '#FFA500', 255, 165, 0 },
  { 'moccasin', '#FFE4B5', 255, 228, 181 },
  { 'papayawhip', '#FFEFD5', 255, 239, 213 },
  { 'blanchedalmond', '#FFEBCD', 255, 235, 205 },
  { 'navajowhite', '#FFDEAD', 255, 222, 173 },
  { 'antiquewhite', '#FAEBD7', 250, 235, 215 },
  { 'tan', '#D2B48C', 210, 180, 140 },
  { 'burlywood', '#DEB887', 222, 184, 135 },
  { 'darkorange', '#FF8C00', 255, 140, 0 },
  { 'bisque', '#FFE4C4', 255, 228, 196 },
  { 'linen', '#FAF0E6', 250, 240, 230 },
  { 'peru', '#CD853F', 205, 133, 63 },
  { 'peachpuff', '#FFDAB9', 255, 218, 185 },
  { 'sandybrown', '#F4A460', 244, 164, 96 },
  { 'chocolate', '#D2691E', 210, 105, 30 },
  { 'saddlebrown', '#8B4513', 139, 69, 19 },
  { 'seashell', '#FFF5EE', 255, 245, 238 },
  { 'sienna', '#A0522D', 160, 82, 45 },
  { 'lightsalmon', '#FFA07A', 255, 160, 122 },
  { 'coral', '#FF7F50', 255, 127, 80 },
  { 'orangered', '#FF4500', 255, 69, 0 },
  { 'darksalmon', '#E9967A', 233, 150, 122 },
  { 'tomato', '#FF6347', 255, 99, 71 },
  { 'salmon', '#FA8072', 250, 128, 114 },
  { 'mistyrose', '#FFE4E1', 255, 228, 225 },
  { 'lightcoral', '#F08080', 240, 128, 128 },
  { 'snow', '#FFFAFA', 255, 250, 250 },
  { 'rosybrown', '#BC8F8F', 188, 143, 143 },
  { 'indianred', '#CD5C5C', 205, 92, 92 },
  { 'red*', '#FF0000', 255, 0, 0 },
  { 'brown', '#A52A2A', 165, 42, 42 },
  { 'firebrick', '#B22222', 178, 34, 34 },
  { 'darkred', '#8B0000', 139, 0, 0 },
  { 'maroon*', '#800000', 128, 0, 0 },
  { 'white*', '#FFFFFF', 255, 255, 255 },
  { 'whitesmoke', '#F5F5F5', 245, 245, 245 },
  { 'gainsboro', '#DCDCDC', 220, 220, 220 },
  { 'lightgrey', '#D3D3D3', 211, 211, 211 },
  { 'silver*', '#C0C0C0', 192, 192, 192 },
  { 'darkgray', '#A9A9A9', 169, 169, 169 },
  { 'gray*', '#808080', 128, 128, 128 },
  { 'dimgray', '#696969', 105, 105, 105 },
  { 'black*', '#000000', 0, 0, 0 },
}
local result = {}

for i, color in ipairs(colors) do
  if i > 1 then
    local guess = with_hsluv(color[2])
    table.insert(color, guess)
    table.insert(result, vim.fn.json_encode(color))
    -- print("'" .. vim.fn.json_encode(color) .. "'")
    -- print(result[i - 1])
  end
end

-- print(vim.inspect(result))

return result
