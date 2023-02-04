# Install JetBrainsMono font

[Which font?](https://github.com/ryanoasis/nerd-fonts/wiki/FAQ-and-Troubleshooting#which-font)

## Windows

1. run the code below

```bash
$ wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
$ unzip ./JetBrainsMono.zip -d jetbrains
$ ls -1 | grep -P '(?<!JetBrains) Mono' | xargs -I {} rm "{}"
$ ls -1 | grep -v "Windows Compatible" | xargs -I {} rm "{}" 
$ ls -1 | grep "NL" | xargs -I {} rm "{}"
```

2. install remaining fonts
