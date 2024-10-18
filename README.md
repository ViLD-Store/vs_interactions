![image](https://github.com/user-attachments/assets/86a3b12a-fb86-4150-8d36-f0e1ba9a3962)
# vs_interactions

`vs_interactions` is a versatile library designed to create dynamic and immersive in-game interactions with NPCs, objects, and props in your FiveM server. This resource allows for customizable mission systems, event-driven triggers, and seamless action menus, all enhanced by a clean and modern UI. Whether you need distance-based interactions, conditional logic, or icon-driven menus, `vs_interactions` is built to make your gameplay more interactive and engaging.

## Key Features
- **Easy Setup**: Get started quickly with minimal configuration.
- **Seamless Integration**: Easily integrate with your existing scripts.
- **Optimized Performance**: Designed for efficient performance, ensuring no impact on gameplay.
- **Customizable Options**: Use exports to add flexibility to your interactions.
- **Supports FontAwesome Icons**: Enhance your menus with recognizable icons.

## Installation

Follow these simple steps to install `vs_interactions`:

1. **Download** the `vs_interactions` script from the repository.
2. **Extract** the folder into your server's `resources` directory.
3. **Edit** your `server.cfg` to include `ensure vs_interactions` to load the resource.
4. **Restart** your server and enjoy dynamic interactions in-game!

## Usage Example

You can easily add a local entity with customizable interaction options using this export function:

```lua
exports.vs_interactions:addLocalEntity({
    entity = spawnedPed, -- Ped entity
    icon = "fa-solid fa-user-ninja", -- optional (from fontawesome.com)
    distance = 2.0, -- Interaction distance
    options = {
        {
            label = 'Test',
            event = 'vs_interactions:BuyCoffee', -- Example serverEvent
            onSelect = function()  
                -- Code executed upon selection
            end,
            canInteract = function()
                -- Conditions to check if interaction is possible
                return true
            end
        },
    }
})
```
Additional functions can be found in the `client/exports.lua` file.

---

## Support & Community

Have questions or suggestions? Join our community and get help:

- **Discord:** [Join us on Discord](https://discord.gg/vild) for support and updates.
- **YouTube:** [Watch our videos](https://www.youtube.com/@VildStore) for tutorials and showcases.
- **TikTok:** [Follow us on TikTok](https://www.tiktok.com/@vildstore) for behind-the-scenes content.
- **Tebex Store:** [Visit our Tebex Store](https://vildstore.com) for more exciting resources.

---

## License

`vs_interactions` is licensed under the MIT License. For more details, see the [LICENSE](./LICENSE) file.
