# B3T: Better Todo Than (your) Todo

_Lightweight, offline-first todo tracker for developers. Built with Zig._  
No bloat, no cloud, just your tasks.

[![Zig Version](https://img.shields.io/badge/Zig-0.14.0-%23ec7c0c)](https://ziglang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 🚀 Why B3T?

For developers tired of:

- **Cloud-dependent tools** that break without Wi-Fi.
- **Heavyweight apps** that drain resources.
- **Scattered TODOs** buried in code comments.

B3T solves this with **local-first task management** and seamless codebase integration.

---

## ✨ Features

- **📴 Offline-First**  
  Work from a cabin, train, or server room. No accounts, no sync, no BS.
- **⚡ Lua-Driven Plugins**  
  Add features **without recompiling**—plugins are dynamic Lua scripts.
- **🔎 Codebase-Aware**  
  Automatically find `// TODO:` comments with `b3t scan`.
- **📂 Project-Centric**  
  Define projects via `todo.toml`. Templates included.
- **🔌 Minimal Dependencies**  
  Built with Zig for speed, extended with Lua for flexibility.

---

## 🛠️ Quick Start

1. **Install** (requires [Zig](https://ziglang.org) and [Lua 5.4](https://lua.org)):

   ```bash
   git clone https://github.com/gasfurr/b3t
   cd b3t
   ./install.sh  # Installs B3T with bash script.
   ```

2. **Init a Project**:

   ```bash
   b3t init  # Creates todo.toml in your project
   ```

3. **Scan for TODOs**:

   ```bash
   b3t scan  # Detects TODOs in code comments
   ```

4. **List Tasks**:

   ```bash
   b3t list  # Shows tasks from code + todo.toml
   ```

---

## 📝 Example Workflow

**1. Create your `mytemplate.toml`:**

```toml
[project]

name = "my_awesome_app"
auto_scan = true  # Auto-detect TODOs on Scan

[options]
scan.taskName = "//B3T-TODO:" # Confugure parser
# Enabling multiline scanning
scan.taskMultiline = true
scan.multiStart = "///B3T-TODO:"
scan.multiEnd = "*///"
# Priorities configuration
priorities = [HIGH, MED, LOW, CRIT] #2, 3, 4, 1
priorities.level [2, 3, 4, 1] # Just write it in same order
priorities.smallToBig = true # if false - will be from big to small.
priorities.flag = "b3t.priority=" #It will find the keyword and set priority
# And everything else... (more in docs)
project.ignore = ["src/stolencode.rs", "src/privatelinks.txt"] # Will not read this files
```

**2. Write Code with TODOs:**

```rust
// main.rs
fn main() {
    //B3T-TODO: Fix memory leak b3t.priority=CRIT
    //B3T-TODO: Fix the typo in print b3t.priority=LOW
    //B3T-TODO: someunpriorityzed todo
    // my api token: lolyoureallyleakedapitokenintodos?
    //B3T-TODO: Multithreading support b3t.priority=MED
}
```

**3. Do the work:**

```bash
~ b3t save mytemplate.toml mytemplate
# Save your templates.
~ cd home/my_awesome_app
# Go to your project root
~ b3t init my_awesome_app -t mytemplate
# Creates todo.toml by your template (stored in program)
~ b3t scan # When you in your projects root
# Detects the comments using todo.toml configuration
~ cd /home/.homework # Now you can do anything
~ b3t list my_awesome_app # Just ask for your project's List
|> my_awesome_app todo:
| ► 1.[CRIT] Fix memory leak
|   → src/main.rs:2
| ► 2.[MED] Multithreading support
|   → src/main.rs:6
| ► 3.[LOW] Fix the typo in print
|   → src/main.rs:3
| ► 4.[] someunpriorityzed todo
|   → src/main.rs:4
# And then you can just delete your project from database anytime
~ b3t unload my_awesome_app
|> Are you sure? [Yes/any key]
# So easy, isn't it?
```

---

## 🧠 Philosophy

- **Your Machine, Your Rules**  
  Tasks stay on your device. No telemetry, no hidden sync.
- **Templates Over Boilerplate**  
  Configure once, reuse everywhere. No more copy-pasting project setups.
- **Minimalist by Design**  
  No GUIs, no plugins—just a CLI that stays out of your way.

---

## 🤝 Contributing

B3T is **open source** ([MIT](LICENSE)). We welcome:

- **Templates**: Share `todo.toml` presets for frameworks (React, Zig, etc.).
- **Core Improvements**: Zig optimizations or new scanning features.
- **Documentation**: Improve guides for advanced configuration.

Check [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## ❓ FAQ

**Q: Why Zig?**  
A: For raw speed and explicit control. And i just love this language, it's _the_ c but better as i see it.
|> I just feel like writing good software is best support for new programming language.

**Q: Can I sync across devices?**  
A: Not directly—by design. But B3T creates .todo directory where it stores all data.
|> You can try version-control B3T database with git.

**Q: How to exclude files from scanning?**  
A: Use `project.ignore` in your template. Supports global patterns.
|> It will not even try scanning files excluded with `project.ignore`.

**Q: Why no GUI?**  
A: To keep focus on terminal workflows. Pipe `b3t list` to other tools if needed.
|> But maybe someone will fork B3T and wrap it in GUI or TUI, who knows?

**Q: But what if i want more features?**
A: Keep an eye on BTBTodo , it's fork of this project where i try to implement lua plugin system.
|> For now i justify lack of plugins by minimalism.

---

**Made by developers, for developers.**
