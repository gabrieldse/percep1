import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Creating a 3-dimensional array
arr = np.array([[[1, 2, 3],
                 [4, 5, 6],
                 [7, 8, 9]],
                [[1, 2, 3],
                 [4, 5, 6],
                 [7, 8, 9]],
                [[19, 20, 21],
                 [22, 23, 24],
                 [25, 26, 27]]])

# Extracting dimensions
#x, y, z = np.indices(arr.shape)
x = arr[:, :, 0]
y = arr[:, :, 1]
z = arr[:, :, 2]

# Creating a 3D plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plotting the 3D surface
ax.scatter(x, y, z)

# Adding labels
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

# Display the plot
plt.show()
