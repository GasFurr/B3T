<div align="center">

[![Zig Version](https://img.shields.io/badge/Zig-0.15.0-%23ec7c0c)](https://ziglang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

-----

> **⚠️ Work In Progress:**
> B3T is currently under active development. The features and workflow described below represent the final vision and are not yet fully  implemented.

-----

# B3T: Better Todo Than (your) Todo

**B3T** is a lightweight, offline-first todo tracker for developers, engineered with Zig. No bloat, no cloud, just your tasks – directly from your codebase.

### **Core Capabilities**

* **📴 Offline-First** Work from a cabin, train, or server room. No accounts, no sync, no BS.
* **⚡ Zig-Powered Simplicity** Single binary, zero runtime dependencies. Just works.
* **🔎 Codebase-Aware** Automatically find todo comments with `b3t scan`.
* **📂 Template-Driven** Define project configurations via `b3t.toml` templates. Reuse settings across projects.
* **🔒 Minimalist by Default** No GUIs, no plugins, no distractions.
-----

### **Getting Started**

1.  **Install** (requires [Zig](https://ziglang.org)):

    ```bash
    git clone [https://github.com/gasfurr/b3t](https://github.com/gasfurr/b3t)
    cd b3t
    ./install.sh # Installs B3T and sets up initial configuration files.
    ```
> **Note:** The `install.sh` script configures B3T for the current user only, aligning with its design as a streamlined, single-user tool.

2.  **Init a Project**:

    ```bash
    b3t init # Creates a default b3t.toml in your current project root.
    ```

3.  **Scan for TODOs**:

    ```bash
    b3t scan # Detects TODOs based on the b3t.toml configuration in your codebase.
    ```

4.  **List Tasks**:

    ```bash
    b3t list # Displays tasks parsed from your code.
    ```

-----

### **Example Workflow**

**1. Create your `mytemplate.toml`:**

```toml
[project]

name = "my_awesome_app"

[options]
scan.taskName = "//B3T-TODO:" # Configure parser
# Priorities configuration
priorities = [ "HIGH", "MED", "LOW", "CRIT"] #2, 3, 4, 1
priorities.level = [2, 3, 4, 1] # Just write it in same order
priorities.flag = "b3t.priority=" #It will find the keyword and set priority
# Ignore configuration
project.ignore = ["src/stolencode.rs", "src/privatelinks.txt"] # Will not read this files
# And everything else... (more in docs)
````

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
~ cd home/my_awesome_app
# Go to your project root
~ b3t init my_awesome_app -t mytemplate
# Creates b3t.toml by your template (stored in program)
~ b3t scan # When you're in your project's root
# Detects the comments using b3t.toml configuration. (It scans all files if not said otherwise.)
~ cd /home/.homework # Now you can do anything
~ b3t list my_awesome_app # Just ask for your project's Todo list!
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

-----

### **Our Philosophy**

  * **Your Machine, Your Rules** Tasks stay on your device. No telemetry, no hidden sync.
  * **Templates Over Boilerplate** Configure once, reuse everywhere. No more copy-pasting.
  * **Small and Focused** Does one thing well: track TODOs in code. Nothing else.

-----

### **Contributing to B3T**

B3T is **open source** ([MIT](LICENSE)). We welcome:

  * **Templates**: Share `b3t.toml` presets for frameworks.
  * **Core Improvements**: Zig optimizations or bug fixes.
  * **Documentation**: Improve guides for advanced configs.

Check [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

-----

### **Frequently Asked Questions**

**Q: Why Zig?**

A: For raw speed and explicit control. And I just love this language; it's *the* C but better, as I see it.

> I just feel like writing good software is best support for new programming language.

**Q: How to add a task manually?**

A: It's not intended, but you can just create some sort of `todo.txt` and `b3t` will parse it.

> It's a design choice - b3t strictly believes in your codebase as the only true source.

**Q: Can I sync across devices?**

A: Not directly—by design. But you can version-control `.b3t` with Git if you want.

**Q: Why no GUI/plugins?**

A: To stay minimal. Pipe `b3t list` to other tools if needed.

-----

### **Legal Stuff**

B3T is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this code. Please include appropriate attribution (e.g., "© GasFurr") as per the license terms.

This project uses [microwave](https://github.com/edqx/microwave) ([MIT License](https://github.com/edqx/microwave/blob/main/LICENSE)) for TOML parsing.

<div align="center">

`Made by developers, for developers.`
