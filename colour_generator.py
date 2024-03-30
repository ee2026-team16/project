def color_code_to_16bit_rgb(color_code):
    # Convert hexadecimal color code to RGB components
    red = int(color_code[1:3], 16)
    green = int(color_code[3:5], 16)
    blue = int(color_code[5:7], 16)

    # Scale RGB components to fit into 5 and 6 bits
    red_5bit = int(red * (31 / 255))
    green_6bit = int(green * (63 / 255))
    blue_5bit = int(blue * (31 / 255))

    # Combine components into a 16-bit integer
    color_16bit = (red_5bit << 11) | (green_6bit << 5) | blue_5bit

    # Convert to binary format with underscores
    color_binary = bin(color_16bit)[2:].zfill(16)
    color_binary_with_underscores = "_".join(
        [color_binary[:5], color_binary[5:11], color_binary[11:]]
    )

    return "16'b" + color_binary_with_underscores


def rgb_to_16bit_rgb(r, g, b):
    # Scale RGB components to fit into 5 and 6 bits
    red_5bit = int(r * (31 / 255))
    green_6bit = int(g * (31 / 255))
    blue_5bit = int(b * (31 / 255))

    # Combine components into a 16-bit integer
    color_16bit = (red_5bit << 11) | (green_6bit << 5) | blue_5bit

    # Convert to binary format with underscores
    color_binary = bin(color_16bit)[2:].zfill(16)
    color_binary_with_underscores = "_".join(
        [color_binary[:5], color_binary[5:11], color_binary[11:]]
    )

    return "16'b" + color_binary_with_underscores


color_code = "#fbfbf2"
color_binary = color_code_to_16bit_rgb(color_code)
print("16-bit RGB representation:", color_binary)
