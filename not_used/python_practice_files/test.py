import numpy as np
import matplotlib.pyplot as plt
import time

def hough_circle_transform(image, radius_range):
    start_time = time.time()  # Record the start time
    Ny, Nx = image.shape
    max_radius = max(radius_range)
    
    # Initialize accumulator array
    accumulator = np.zeros((Ny, Nx, max_radius))

    # Create a theta array
    thetas = np.linspace(0, 2 * np.pi, 360)

    # Find edge pixels in the image
    edge_pixels = np.argwhere(image > 0)

    # Iterate over edge pixels
    for edge_pixel in edge_pixels:
        y, x = edge_pixel

        # Iterate over possible radii
        for radius in radius_range:
            # Iterate over theta values
            for theta in thetas:
                # Calculate circle center coordinates
                center_x = int(x - radius * np.cos(theta))
                center_y = int(y - radius * np.sin(theta))

                # Check if the center coordinates are within the image bounds
                if 0 <= center_x < Nx and 0 <= center_y < Ny:
                    # Update the accumulator
                    accumulator[center_y, center_x, radius - 1] += 1

    end_time = time.time()  # Record the end time
    execution_time = end_time - start_time
    print(f"Execution time: {execution_time:.4f} seconds")

    return accumulator

def find_circle_parameters(accumulator, threshold):
    Ny, Nx, _ = accumulator.shape

    # Find the peaks in the accumulator
    peaks_y, peaks_x, peaks_r = np.where(accumulator > threshold)

    return peaks_x, peaks_y, peaks_r + 1  # Adding 1 to convert back to 1-based index (radius)

def plot_detected_circles(image, centers_x, centers_y, radii):
    plt.imshow(image, cmap='gray')
    plt.title('Image with Detected Circles')

    for x, y, r in zip(centers_x, centers_y, radii):
        circle = plt.Circle((x, y), r, color='r', fill=False)
        plt.gca().add_patch(circle)

    plt.show()

# Example usage:
# Assuming 'edge_image' is the result of Canny edge detection
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
circle_contour_image = draw_circle_contour(500, 50, 37, 20, 75)
edge_image = circle_contour_image

# Specify the range of radii to consider
radius_range = np.arange(10, 50)

# Perform Hough Transform
accumulator = hough_circle_transform(edge_image, radius_range)

# Find circle parameters
threshold = np.max(accumulator) * 0.8  # Adjust threshold as needed
centers_x, centers_y, radii = find_circle_parameters(accumulator, threshold)

# Plot the image with detected circles
plot_detected_circles(edge_image, centers_x, centers_y, radii)