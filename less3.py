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


# Example string
example_string = "16'b10011_100111_10011"

# Check if any value is less than 3
if check_less_than_3(example_string):
    print("At least one value is less than 3.")
else:
    print("No value is less than 3.")
