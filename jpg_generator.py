from PIL import Image
from colour_generator import rgb_to_16bit_rgb


def check_less_than_3(string):
    # Split the string into parts
    parts = string.split("'")[1].split("_")

    # Extract r, g, and b values
    r = int(parts[0][1:])
    g = int(parts[1])
    b = int(parts[2])

    # Check if any value is less than 3
    if r < 3 or g < 3 or b < 3:
        return True
    else:
        return False


def image_to_bit(image_path):
    # Open the image
    image = Image.open(image_path)

    pixel_width = 61
    pixel_height = 21

    # Resize the image to 96x64 pixels
    image = image.resize((pixel_width, pixel_height))

    # Convert image to RGB mode
    image = image.convert("RGB")

    # Get pixel data
    pixels = list(image.getdata())

    # Convert pixels to 16-bit RGB representations
    color_codes = [rgb_to_16bit_rgb(r, g, b) for r, g, b in pixels]

    # Open a file for writing
    with open("out.txt", "w") as f:
        for i in range(len(color_codes)):
            if color_codes[i] == "16'b00000_000000_00000":
                continue
            elif color_codes[i] == "16'b00001_000000_00000":
                continue
            elif color_codes[i] == "16'b00000_000001_00000":
                continue
            elif color_codes[i] == "16'b00000_000000_00001":
                continue

            offset_x = 17
            # offset_x = 12
            offset_y = 20
            x = i % pixel_width
            y = i // pixel_width
            if x == 0 and y == 0:
                f.write(
                    "if (x == "
                    + str(offset_x + x)
                    + " && y == "
                    + str(offset_y + y)
                    + ")\nbegin\n    pixel_data <= "
                    + color_codes[i]
                    + ";\nend\n"
                )
            else:
                f.write(
                    "else if (x == "
                    + str(offset_x + x)
                    + " && y == "
                    + str(offset_y + y)
                    + ")\nbegin\n    pixel_data <= "
                    + color_codes[i]
                    + ";\nend\n"
                )


# Test with an image file
image_path = "tutorial_2_61_21-removebg-preview.png"
image_binary = image_to_bit(image_path)
