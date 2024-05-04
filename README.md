# NixOS dotfiles

My configuration files for NixOS. Feel free to look around and copy!

![Screenshot of Gnome example](https://github.com/Faustrox/nixos-dotfiles/blob/main/assets/the-hope-desktop.png)

# Info

- Uses the [catppuccin](https://github.com/catppuccin) theme
- Terminal emulator: :cat: kitty
- Desktop environment: Gnome and Plasma available
- Shell: :shell: zsh
- Editor: :pencil: nano
- Browser: Chrome

## Commands to know

- If you have zsh home manager module you can rebuild and switch the system configuration:

```
rebuild
```

OR

```
sudo nixos-rebuild switch --flake .#yourComputer
```

- Update flake.lock

```
update
```

- Remove old generations and keep the last 5 generations.

```
remove-old
```

## Conclusion

This concludes my configuration setup. The associated code is released under the MIT license, which permits users to utilize or disseminate the code at their discretion. Should you encounter any difficulties or have valuable ideas to contribute, please feel free to reach out to me for assistance or collaboration.
