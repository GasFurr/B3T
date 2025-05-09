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
- **⚡ Zig-Powered Simplicity**  
  Single binary, zero runtime dependencies. Just works.
- **🔎 Codebase-Aware**  
  Automatically find `//B3T-TODO` comments with `b3t scan`.
- **📂 Template-Driven**  
  Define projects via `todo.toml`. Reuse configs across projects.
- **🔒 Minimalist by Default**  
  No GUIs, no plugins, no distractions.

---

## 🛠️ Quick Start

1. **Install** (requires [Zig](https://ziglang.org)):

   ```bash
   git clone https://github.com/gasfurr/b3t
   cd b3t
   ./install.sh  # Installs B3T with bash script
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
   b3t list  # Shows tasks from code.
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
# Priorities configuration
priorities = [HIGH, MED, LOW, CRIT] #2, 3, 4, 1
priorities.level [2, 3, 4, 1] # Just write it in same order
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
~ b3t template save mytemplate.toml mytemplate
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
~ b3t delete my_awesome_app
|> Are you sure? [Yes/any key]
# So easy, isn't it?
```

---

## 🧠 Philosophy

- **Your Machine, Your Rules**  
  Tasks stay on your device. No telemetry, no hidden sync.
- **Templates Over Boilerplate**  
  Configure once, reuse everywhere. No more copy-pasting.
- **Small and Focused**  
  Does one thing well: track TODOs in code. Nothing else.

---

## 🤝 Contributing

B3T is **open source** ([MIT](LICENSE)). We welcome:

- **Templates**: Share `todo.toml` presets for frameworks.
- **Core Improvements**: Zig optimizations or bug fixes.
- **Documentation**: Improve guides for advanced configs.

Check [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## ❓ FAQ

**Q: Why Zig?**  
A: For raw speed and explicit control. And i just love this language, it's _the_ c but better as i see it.

> I just feel like writing good software is best support for new programming language.

**Q: How to add task manually?**
A: It's not intended, but you can just create some sort of `todo.txt` and `b3t` will parse it.

**Q: Can I sync across devices?**  
A: Not directly—by design. But you can version-control `.b3t` with Git if you want.

**Made by developers, for developers.**
**Q: Why no GUI/plugins?**  
A: To stay minimal. Pipe `b3t list` to other tools if needed.
(Or maybe someone one time will wrap `b3t` in some sort of gui/tui, i don't know really)

**Q: What if I want more features?**  
A: Keep an eye on [BetterB3T]() for plugins/SQLite. This version is intentionally barebones.

---

**Made by developers, for developers.**
