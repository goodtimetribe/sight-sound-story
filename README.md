# sight-sound-story

PowerShell script for generating hip-hop style writing prompts using the **Sight, Sound, Story** structure.

## Files

- `./Generate-WritingPrompts.ps1`
- `./prompts/sight.yaml`
- `./prompts/sound.yaml`
- `./prompts/story.yaml`

Each YAML file has 20+ entries and can be expanded/customized without changing the script.

## Usage

```powershell
pwsh ./Generate-WritingPrompts.ps1
```

Defaults:
- `OutputFormat`: `markdown`
- `Count`: `20`
- `OutputFile`: `writing-prompts.md` in the current directory

### Output formats

```powershell
pwsh ./Generate-WritingPrompts.ps1 -OutputFormat markdown -OutputFile ./prompts.md
pwsh ./Generate-WritingPrompts.ps1 -OutputFormat json -OutputFile ./prompts.json
pwsh ./Generate-WritingPrompts.ps1 -OutputFormat csv -OutputFile ./prompts.csv
```

### Custom prompt files

```powershell
pwsh ./Generate-WritingPrompts.ps1 \
  -SightFile ./prompts/sight.yaml \
  -SoundFile ./prompts/sound.yaml \
  -StoryFile ./prompts/story.yaml
```
