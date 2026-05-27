
# Vulkan Learning Project

Following the [Vulkan Tutorial](https://vulkan-tutorial.com) by Alexander Overvoorde.
Single-file C++ app, no engine, just raw Vulkan.

## Dependencies

- Vulkan SDK
- GLFW3
- GLM
- stb_image
- tinyobjloader(header-only)

## Building

Compile the shaders first:

```bash
glslc shader.vert -o vert.spv
glslc shader.frag -o frag.spv
```

Make sure `texture.jpg`, `vert.spv`, and `frag.spv` are in the same directory as the binary. 
For object loading ,Make sure your 3D models assets (.obj , .png )are in the same directory aswell



## What it does right now

Renders a fully textured, complex 3D model loaded from an .obj file. It correctly handles geometry overlap using a hardware Depth Buffer (Z-buffer). The camera is set up with a perspective projection, and the model rotates upright around the Z-axis, driven by a UBO updated every frame using std::chrono. The texture is sampled directly by the GPU in the fragment shader using UV coordinates.

---

## Progress

### Instance + Validation
- Creates a `VkInstance` and enables `VK_LAYER_KHRONOS_validation` in debug builds
- Debug messenger set up to catch validation errors/warnings

### Device
- Picks the first GPU that supports a graphics queue, a present queue, and the swapchain extension
- There's a commented-out scoring system that prefers discrete GPUs — left it in for reference

### Swapchain
- Prefers `VK_FORMAT_B8G8R8A8_SRGB` surface format
- Prefers mailbox present mode (triple buffering), falls back to FIFO
- Swap extent clamped to what the GPU supports

### Render Pass + Pipeline
- Single color attachment, clears to black each frame
- Full fixed-function config: triangle list topology, fill mode, counter-clockwise winding, dynamic viewport/scissor, no blending
- Shaders loaded from compiled SPIR-V at runtime
- `Vertex` struct upgraded to include UV coordinates (location 2)
- Depth stencil state enabled with `Vk_COMPARE_OP_LESS`
### Buffers
- Vertex and index buffers both use the staging buffer pattern (CPU writes to host-visible, GPU copies to device-local)
- `createBuffer`, `copyBuffer`, and one-shot command buffer helpers factored out

### Uniform Buffers + Descriptors
- `UniformBufferObject` holds model/view/proj matrices
- One UBO per swapchain image, persistently mapped
- Descriptor Pool upgraded to allocate space for both UBOs and Combined Image Samplers
-Descriptor Sets wired up to Bindings 0(UBO) and binding 1(Texture sampler)

### Textures & Depth
- `stb_image` loads the image and copies pixels into a staging buffer
- `VkImage` created with `VK_IMAGE_TILING_OPTIMAL` and bound to `DEVICE_LOCAL` memory
-Command buffers dynamically transition layout to `TRANSFER_DST_OPTIMAL` , copy the buffer, and transition to `SHADER_READ_ONLY_OPTIMAL` 
-Image view and sampler are created with Linear filtering and Repeat wrapping mode
- Custom `findSupportedFormat` helper queries the GPU for Depth formats
---
## Model Loading 
- `tinyobjloader` integrated to parse standard 3D .obj files

- `Vertex` struct upgraded to full 3D (glm::vec3 pos)

- Implemented a custom `std::hash` template for vertices

- Vertices are automatically deduplicated using a `std::unordered_map` to save GPU memory

## Notes to self

- The GPU scoring/selection approach (commented out in `pickPhysicalDevice`) is the "proper" way for real apps — scores by device type and max texture size
- `VK_CULL_MODE_NONE` is set for now since the geometry is flat and winding order doesn't matter yet
- Anisotropic filtering is disabled in the sampler — easy to enable later by querying device features
- Texture Format Mismatch :standard JPEGs read via `stb_image` load in `R8G8B8A8` format , which is different from Swapchain's `B8G8R8A8`.Ensures the `VkImage` matches the image library , not the monitor 
