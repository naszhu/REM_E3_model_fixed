import json, os

json_path = "log/model_progress.json"
md_path = "log/model_progress.md"

# 安全读取 json
if not os.path.exists(json_path) or os.path.getsize(json_path) == 0:
    log = []
else:
    try:
        with open(json_path, "r") as f:
            log = json.load(f)
    except json.JSONDecodeError:
        log = []

with open(md_path, "w") as f:
    f.write("# Model Progress\n\n")
    for entry in log:
        sha = entry.get("commit", "unknown")
        branch = entry.get("branch", "unknown")
        msg = entry.get("message", "")
        ts = entry.get("timestamp", "")
        plot1 = entry.get("plot1", "")
        plot2 = entry.get("plot2", "")
        files = entry.get("changed_files", [])

        f.write(f"## Commit [{sha}](https://github.com/naszhu/REM_E3_model_fixed/commit/{sha}) (branch: `{branch}`)\n")
        f.write(f"**Message:** {msg}  \n")
        f.write(f"**Time:** {ts}  \n")
        if files:
            f.write(f"**Changed Files:**\n")
            for fname in files:
                f.write(f"- `{fname.strip()}`  \n")
        if plot1:
            f.write(f"![]({plot1})  \n")
        if plot2:
            f.write(f"![]({plot2})  \n")
        f.write("\n")
