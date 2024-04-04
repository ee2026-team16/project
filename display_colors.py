import matplotlib.pyplot as plt


def normalize_rgb(rgb):
    return tuple(x / 255 for x in rgb)


def display_colors(colors_rgb):
    # Create a figure and axis
    fig, ax = plt.subplots(1, len(colors_rgb), figsize=(10, 2))

    # Iterate over colors and display them
    for i, color in enumerate(colors_rgb):
        normalized_color = normalize_rgb(color)
        # Create a patch with the color
        rect = plt.Rectangle((0, 0), 1, 1, color=normalized_color)
        ax[i].add_patch(rect)
        ax[i].axis("off")

        # Set title with RGB values
        ax[i].set_title(f"RGB\n{color}", fontsize=10)

    plt.show()


# Example usage:
segmented_colors = [
    (122, 169, 222),
    (0, 11, 35),
    (59, 88, 150),
    (177, 162, 246),
    (0, 0, 0),
]
display_colors(segmented_colors)
