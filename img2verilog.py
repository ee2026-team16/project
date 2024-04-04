from PIL import Image
import os

def binarize(image_to_transform, threshold, name, f, offset_x, offset_y):
    # Convert the image to a single greyscale image
    output_image = image_to_transform.convert("L")
    
    mystring = f"assign {name} = ("
    firstopen = True
    
    for y in range(output_image.height):
        opened = False
        numopens = 0
        
        for x in range(output_image.width):
            # Check pixel value against the threshold
            if output_image.getpixel((x, y)) > threshold:
                output_image.putpixel((x, y), 0)
                if opened:
                    mystring += f" && x < {x + offset_x})"
                    opened = False
            else:
                if not opened:
                    if numopens == 0:
                        if not firstopen:
                            mystring += " || \n"
                        firstopen = False
                        mystring += f"((y == {y + offset_y}) && ((x >= {x + offset_x}"
                    else:
                        mystring += f" || (x >= {x + offset_x}"
                    opened = True
                    numopens += 1
                output_image.putpixel((x, y), 255)
        
        if opened:
            mystring += ")))"
        elif numopens > 0:
            mystring += "))"
    
    mystring += ");\n\n"
    f.write(mystring)
    
    return output_image

# Path to the image
image_path = "mole_outline.png"

# Open the image
img = Image.open(image_path)
img = img.resize((26, 23))

# Output file for Verilog code
verilog_file = open("tmp.txt", "w")

# mole 1
mole_1_x = 8
mole_1_y = 22

# mole 2
mole_2_x = 34
mole_2_y = 22

# Call binarize function
binarize(img, 200, "mole_2_outline", verilog_file, mole_2_x, mole_2_y).save("tmp.png")

# Close the Verilog file
verilog_file.close()