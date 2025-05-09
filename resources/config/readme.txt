It's your configuration directory
b3t have some default configs that's more than suitable for everyday use.
But if you want to tinker, that's how it works:
.
├── readme.txt - It's readme file, the more you know.mp4.
├── settings.toml - It's main setting file.
├── default-init.toml - Stores all your default settings.
├── templates - Here are all your templates.
│   └── default.toml - It's default template.
└── visual - It's interesting. There you store "skins" for b3t.
    ├── default.toml - Default fancy skin (you saw that in github)
    └── minimal.toml - Minimalistic skin for clean look.
---

settings.toml - File you need to have.
b3t have to check it literally every time you bother it.
Here stored all paths to your .todo, your data dir, templates dir, all paths.
Here stored your current skin, default template, versioning data(you better not change it.)
Here you can even configure your commands name, you can easily rename "b3t delete" to "b3t kill"

---

default-init.toml - It's file that stores ALL template settings.
b3t checks it every time you left something behind.
It makes life easier by giving you right to not set all template variables.
If you didn't set "scan.taskMultiline" it will use this file to find what the default was.
This file lets you left your "priorities.smallToBig" untouched, making it true by default.

---

templates - directory for all your templates (wow, everything really named self-explanatory)
b3t checks this folder every time you run b3t init.
It checks for new templates and copies here all templates you add with b3t template save.
All templates (as all configs) are toml files.

---

default.toml - It's the default. The base.
Every time you b3t init your project - b3t checks this file.
It's just basic settings file with just three meaningful lines that every template should have.
'
[project]
name = "..."
[options]
'
Everything else it uses default-init. Genius in simpicity.

---

visual - directory that stores your fancy skins.
b3t checks it every time you write b3t list.
there you can place all thing that make you a person.
There stored all your skins like "iUseArchBtw.toml"
All your dark fantasies come true here.

---

default.toml - toml might be strange idea for this type of task.
But why not just use toml everywhere, why i didn't just write all code in toml, right?
Yeah, it's not the most wise idea of mine, but it works.
So, default skin you see. 
`
|> my_awesome_app todo:
| ► 1.[CRIT] Fix memory leak
|   → src/main.rs:2
| ► 2.[MED] Multithreading support
|   → src/main.rs:6
| ► 3.[LOW] Fix the typo in print
|   → src/main.rs:3
| ► 4.[] someunpriorityzed todo
|   → src/main.rs:4
`

---

minimal.toml - Just another pre-delivered skin for all you minimalistic lunatics.
Just clean skin for you, with love (i use it too btw.)
`
  Project: my_awesome_app
1.CRIT - Fix memory leak
  src/main.rs:2
2.MED - Multithreading support
  src/main.rs:6
3.LOW - Fix the typo in print
  src/main.rs:3
4. - someunpriorityzed todo
  src/main.rs:4
`

---

Being real - toml is really, maybe too good for configurations.
And i think it's good because my target audience, all theese rust devs 
(arch users who write their code in nvim) already meet with toml.

I just love yapping, knowing that - go read docs and write your masterpiece,
your magnum opus, your ninth symphony, your Sistine Chapel ceiling of all configurations.
(And then share it somewhere on reddit... Why there still no r/configporn?)
