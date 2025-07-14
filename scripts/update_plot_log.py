import sys, json, os, subprocess

commit, branch, head_message, timestamp, plot1, plot2, changed_files = sys.argv[1:]
changed_list = changed_files.split(",") if changed_files else []

# 获取完整 commit message（含 body）
def get_full_commit_message(commit_sha):
    try:
        # Get the full commit message including body
        full_message = subprocess.check_output(
            ["git", "show", "-s", "--format=%B", commit_sha],
            text=True
        ).strip()
        
        # If the full message is empty or just whitespace, fall back to head message
        if not full_message or full_message.isspace():
            return head_message
        
        return full_message
    except subprocess.CalledProcessError:
        return head_message

# 获取 commit 的 subject (first line) 和 body (rest of the message)
def get_commit_parts(commit_sha):
    try:
        # Get subject (first line)
        subject = subprocess.check_output(
            ["git", "show", "-s", "--format=%s", commit_sha],
            text=True
        ).strip()
        
        # Get body (everything after first line)
        body = subprocess.check_output(
            ["git", "show", "-s", "--format=%b", commit_sha],
            text=True
        ).strip()
        
        return subject, body
    except subprocess.CalledProcessError:
        return head_message, ""

# 获取 reflog（从前一个 commit 到当前 commit 之间）
def get_reflog_between_commits(commit_sha):
    try:
        reflog = subprocess.check_output(["git", "reflog"], text=True).splitlines()
    except subprocess.CalledProcessError:
        return []

    entries = []
    collecting = False
    for line in reflog:
        if commit_sha in line:
            collecting = True
            continue
        if collecting:
            if "commit" in line or "checkout" in line:
                entries.append(line.strip())
            else:
                break
    return entries

# Get full message and separate parts
full_message = get_full_commit_message(commit)
subject, body = get_commit_parts(commit)
reflog_entries = get_reflog_between_commits(commit)

# 创建 entry with both full message and separated parts
entry = {
    "commit": commit,
    "branch": branch,
    "message": full_message,  # Full message (subject + body)
    "subject": subject,       # Just the subject line
    "body": body,            # Just the body (if any)
    "timestamp": timestamp,
    "plot1": plot1,
    "plot2": plot2,
    "changed_files": changed_list,
    "reflog": reflog_entries
}

log_path = "log/model_progress.json"

# 写入 json
if os.path.exists(log_path):
    try:
        with open(log_path, "r") as f:
            log = json.load(f)
    except json.JSONDecodeError:
        log = []
else:
    log = []

log.insert(0, entry)

with open(log_path, "w") as f:
    json.dump(log, f, indent=2)

print(f"Added commit {commit} to progress log")