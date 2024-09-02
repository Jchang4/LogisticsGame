# Logistics Game

TODO: add video

Logistics Game is a high-stakes strategy game where you race against the clock to deliver packages from Warehouses to Businesses using your fleet of Vehicles. Packages spawn constantly, and it's up to you to ensure they're delivered on time. Miss a delivery, and it’s game over!

## Learnings

Building Logistics Game for Vision OS on the Apple Vision Pro has been an exciting journey into the world of spatial computing. The experience provided valuable insights into effectively leveraging Entity Component System (ECS) architecture, managing 3D models, and optimizing game design for a dynamic, immersive environment. Here are some of the key learnings:

* **Efficient Use of ECS Architecture**: Mastered how to implement ECS for better performance and scalability, ensuring smooth management of game entities and their components, and stable/fast framerates.
* **3D Model Management**: Developed skills in handling 3D model entities and their associated data, enabling the creation of visually cohesive and interactive game elements.
* **Generalized Systems**: Learned to create separated, generalized Systems that can be reused across different parts of the game, enhancing modularity and maintainability.
* **3D Model Positioning**: Overcame challenges in positioning and aligning 3D models.
* **Efficient Memory Management**: Refined the architecture through directed trial and error, **achieving stable framerates up to a 50 x 50 board**
* **NxN Board Efficiency**: Designed an efficient NxN board layout, optimizing the movement of entities across the board for better gameplay mechanics.
* **Stateful Attachments**: Implemented individual attachments with state to separate models, adding layers of information and functionality, enriching the gameplay experience.
* **Dynamic Selection Tiles**: Integrated dynamic selection tiles that enhance user interaction and make gameplay more intuitive.
* **Randomized Board Generation**: Successfully created a randomly generated board that strategically minimizes roads between Warehouses and Buildings, introducing chokepoints that increase the game's difficulty by causing more collisions.

This project not only honed my skills in spatial computing but also deepened my understanding of how to effectively combine ECS architecture with 3D modeling and gameplay mechanics in a complex VR/AR environment.
