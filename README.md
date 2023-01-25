# 3d Ascii Sphere 🌐
![](https://img.shields.io/badge/ASCII_Sphere-_Made_By_Jh1sc-yellow?style=for-the-badge)


## Description ♨️
This script utilizes trigonometric calculations to generate a three-dimensional representation of a sphere, utilizing the Point3D class of the System.Windows.Media.Media3D namespace. The buffer and window size of the console are configured to a specific resolution, and the font is altered to enhance the visual aesthetic of the rendered sphere.

The script employs a while loop to continuously rotate the sphere, manipulating the x, y, and z coordinates of each point in the sphere's vertex array through the application of trigonometric functions. This rotation is achieved through the utilization of the sine and cosine functions, with a variable theta determining the angular displacement of each iteration.

Additionally, the script implements a simulated illumination process, utilizing the cursor position as the source of light. The script calculates the intensity of the light illuminating each point on the sphere by utilizing the distance between the cursor position and the point being evaluated. This intensity value is then used to determine the appropriate shading character to be rendered, providing a dynamic and visually striking representation of the illuminated sphere.
