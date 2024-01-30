import numpy as np
import matplotlib.pyplot as plt

def draw_circle_contour(image_size, center_x, center_y, radius, thickness):
    # Create a black image
    image = np.zeros((image_size, image_size), dtype=np.uint8)

    # Draw the contour of the circle
    y, x = np.ogrid[:image_size, :image_size]
    distance_squared = (x - center_x)**2 + (y - center_y)**2
    mask_outer = np.abs(distance_squared - radius**2) <= thickness / 2
    mask_inner = np.abs(distance_squared - (radius - thickness)**2) <= thickness / 2
    image[mask_outer & ~mask_inner] = 255  # Set pixels on the contour to white (255)

    return image

# Example usage:
circle_contour_image = draw_circle_contour(75, 37, 37, 20, 75)

# Display the image
plt.imshow(circle_contour_image, cmap='gray')
plt.title('Image with Circle Contour')
plt.show()
