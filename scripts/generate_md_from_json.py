import json
import subprocess
from pathlib import Path

json_path = Path("log/model_progress.json")
md_path = Path("log/model_progress.md")
repo_url = "https://github.com/naszhu/REM_E3_model_fixed/commit"

def get_reflog_between_commits(current_commit):
    """Get reflog entries from the previous commit up to current_commit."""
    reflog = subprocess.run(["git", "reflog"], capture_output=True, text=True).stdout.splitlines()
    collecting = False
    entries = []
    for line in reflog:
        if current_commit in line:
            collecting = True
            continue
        if collecting:
            if "commit" in line or "checkout" in line:
                entries.append(line)
            else:
                break
    return entries

def generate_md():
    if not json_path.exists():
        print("JSON log not found.")
        return

    with open(json_path, "r", encoding="utf-8") as f:
        logs = json.load(f)

    lines = ["# Model Progress Log\n"]

    for log in reversed(logs):
        commit = log["commit"]
        lines.append(f"## Commit [`{commit}`]({repo_url}/{commit})  `({log['branch']})`")
        lines.append(f"- **Message**: {log['message']}")
        lines.append(f"- **Timestamp**: {log['timestamp']}")
        lines.append(f"- **Changed Files**: `{', '.join(log['changed_files'])}`")
        lines.append("")
        lines.append("**Plots:**  ")
        lines.append(f"![plot1]({log['plot1']})")
        lines.append(f"![plot2]({log['plot2']})")
        lines.append("")

        # reflog entries between commits
        reflog_lines = get_reflog_between_commits(commit)
        if reflog_lines:
            lines.append("**Git Reflog Since Previous Commit:**")
            lines.append("```")
            lines.extend(reflog_lines)
            lines.append("```")

        lines.append("\n---\n")

    md_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"✅ Markdown updated: {md_path}")

if __name__ == "__main__":
    generate_md()
