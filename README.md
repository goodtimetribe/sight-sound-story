# sight-sound-story

PowerShell script for generating hip-hop style writing prompts using the **Sight, Sound, Story** structure.

## Files

- `./Generate-WritingPrompts.ps1`
- `./prompts/sight.yaml`
- `./prompts/sound.yaml`
- `./prompts/story.yaml`
- `./prompts/scifi/sight.yaml`
- `./prompts/scifi/sound.yaml`
- `./prompts/scifi/story.yaml`
- `./prompts/fantasy/sight.yaml`
- `./prompts/fantasy/sound.yaml`
- `./prompts/fantasy/story.yaml`

Each YAML file has 20+ entries and can be expanded/customized without changing the script.

## Usage

```powershell
pwsh ./Generate-WritingPrompts.ps1
```

Defaults:
- `OutputFormat`: `json`
- `Count`: `1`
- `OutputFile`: `writing-prompts-<timestamp>.json` in the current directory
- `PromptsFolder`: `./prompts`

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

### Prompt folder selection

```powershell
pwsh ./Generate-WritingPrompts.ps1 -PromptsFolder ./prompts/scifi
```
