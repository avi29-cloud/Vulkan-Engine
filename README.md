
# Vulkan Learning Project

Following the [Vulkan Tutorial](https://vulkan-tutorial.com) by Alexander Overvoorde.
Single-file C++ app, no engine, just raw Vulkan.

## Dependencies

- Vulkan SDK
- GLFW3
- GLM
- stb_image

## Building

Compile the shaders first:

```bash
glslc shader.vert -o vert.spv
glslc shader.frag -o frag.spv
```

Make sure `texture.jpg`, `vert.spv`, and `frag.spv` are in the same directory as the binary.

## What it does right now

Renders a colored rectangle that rotates over time. Camera is set up with a perspective projection, and the rotation is driven by a UBO updated every frame using `std::chrono`. The four corners are red, green, blue, and white.

Texturing infrastructure is partially in place (image view + sampler are created) but the texture isn't actually mapped onto the geometry yet — that's the next step.

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

### Buffers
- Vertex and index buffers both use the staging buffer pattern (CPU writes to host-visible, GPU copies to device-local)
- `createBuffer`, `copyBuffer`, and one-shot command buffer helpers factored out

### Uniform Buffers + Descriptors
- `UniformBufferObject` holds model/view/proj matrices
- One UBO per swapchain image, persistently mapped
- Descriptor set layout, pool, and sets all wired up

### Textures (partial)
- `stb_image` loads the image and copies pixels into a staging buffer
- Image view and sampler are created
- Still need: actual `VkImage` creation, memory binding, and layout transition (`transitionImageLayout`)

---

## Notes to self

- The GPU scoring/selection approach (commented out in `pickPhysicalDevice`) is the "proper" way for real apps — scores by device type and max texture size
- `VK_CULL_MODE_NONE` is set for now since the geometry is flat and winding order doesn't matter yet
- Anisotropic filtering is disabled in the sampler — easy to enable later by querying device features