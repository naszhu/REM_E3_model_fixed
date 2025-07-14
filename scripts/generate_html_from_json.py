import json
import os
from datetime import datetime
import html

json_path = "log/model_progress.json"
html_path = "log/model_progress.html"

def create_tooltip_sha(sha, reflog):
    """Create a styled commit SHA link with formatted tooltip"""
    if not reflog:
        tooltip = "No reflog available"
    else:
        # Format reflog entries with proper line breaks and escaping
        formatted_reflog = []
        for entry in reflog:
            # Clean up the entry and escape HTML
            clean_entry = html.escape(entry.strip())
            formatted_reflog.append(clean_entry)
        tooltip = "\\n".join(formatted_reflog)
    
    return f'''<a href="https://github.com/naszhu/REM_E3_model_fixed/commit/{sha}" 
              class="commit-link" 
              data-tooltip="{tooltip}">{sha}</a>'''

def format_timestamp(timestamp):
    """Format timestamp in a more readable way"""
    try:
        dt = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
        return dt.strftime("%B %d, %Y at %I:%M %p")
    except:
        return timestamp

def generate_css():
    """Generate comprehensive CSS styling"""
    return '''
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        h1 {
            font-size: 2.5em;
            font-weight: 300;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .subtitle {
            font-size: 1.1em;
            opacity: 0.9;
            font-weight: 300;
        }
        
        .content {
            padding: 40px;
        }
        
        .commit-entry {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            border-left: 5px solid #667eea;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }
        
        .commit-entry:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        
        .commit-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .commit-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white !important;
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            font-family: 'Courier New', monospace;
            position: relative;
            transition: all 0.3s ease;
            display: inline-block;
        }
        
        .commit-link:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .branch-badge {
            background: #28a745;
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.85em;
            font-weight: 500;
        }
        
        .timestamp {
            color: #666;
            font-size: 0.9em;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .timestamp::before {
            content: "🕒";
        }
        
        .message-section {
            margin: 20px 0;
        }
        
        .section-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        
        .commit-message {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            line-height: 1.4;
            color: #495057;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .commit-subject {
            margin-bottom: 15px;
        }
        
        .subject-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            font-size: 0.9em;
        }
        
        .subject-text {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            color: #495057;
            font-weight: 600;
        }
        
        .commit-body {
            margin-top: 15px;
        }
        
        .body-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            font-size: 0.9em;
        }
        
        .body-text {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 15px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            line-height: 1.4;
            color: #495057;
            white-space: pre-wrap;
            word-wrap: break-word;
            min-height: 50px;
        }
        
        .files-section {
            margin: 20px 0;
        }
        
        .files-list {
            list-style: none;
            background: white;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #e9ecef;
        }
        
        .files-list li {
            padding: 8px 0;
            border-bottom: 1px solid #f8f9fa;
            color: #495057;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
        }
        
        .files-list li:last-child {
            border-bottom: none;
        }
        
        .files-list li::before {
            content: "📄";
            margin-right: 8px;
        }
        
        .plots-section {
            margin: 20px 0;
        }
        
        .plot-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 15px;
        }
        
        .plot-item {
            background: white;
            border-radius: 12px;
            padding: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .plot-item:hover {
            transform: scale(1.02);
        }
        
        .plot-item img {
            width: 100%;
            height: auto;
            max-width: 400px;
            border-radius: 8px;
            display: block;
        }
        
        .plot-label {
            text-align: center;
            margin-top: 10px;
            font-weight: 600;
            color: #666;
        }
        
        /* Tooltip Styles */
        .commit-link {
            position: relative;
        }
        
        .commit-link::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            font-size: 0.85em;
            white-space: pre-line;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
            z-index: 1000;
            width: 450px;
            word-wrap: break-word;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            font-family: 'Courier New', monospace;
            line-height: 1.4;
            margin-bottom: 10px;
        }
        
        .commit-link::before {
            content: '';
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%) translateY(6px);
            border: 6px solid transparent;
            border-top-color: #333;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
            z-index: 1000;
        }
        
        /* Adjust tooltip position for elements near the left edge */
        .commit-header .commit-link::after {
            left: 0;
            transform: translateX(0);
        }
        
        .commit-header .commit-link::before {
            left: 60px;
            transform: translateX(-50%) translateY(6px);
        }
        
        .commit-link:hover::after,
        .commit-link:hover::before {
            opacity: 1;
            visibility: visible;
        }
        
        .no-data {
            text-align: center;
            padding: 60px;
            color: #666;
            font-size: 1.1em;
        }
        
        .no-data::before {
            content: "📊";
            display: block;
            font-size: 3em;
            margin-bottom: 20px;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            header {
                padding: 20px;
            }
            
            h1 {
                font-size: 2em;
            }
            
            .content {
                padding: 20px;
            }
            
            .commit-entry {
                padding: 20px;
            }
            
            .commit-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .plot-container {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .plot-item img {
                max-width: 100%;
            }
        }
    </style>
    '''

if not os.path.exists(json_path):
    log = []
else:
    try:
        with open(json_path, "r") as f:
            log = json.load(f)
    except json.JSONDecodeError:
        log = []

with open(html_path, "w", encoding="utf-8") as f:
    f.write('<!DOCTYPE html>')
    f.write('<html lang="en">')
    f.write('<head>')
    f.write('<meta charset="UTF-8">')
    f.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">')
    f.write('<title>Model Progress Dashboard</title>')
    f.write(generate_css())
    f.write('</head>')
    f.write('<body>')
    
    f.write('<div class="container">')
    f.write('<header>')
    f.write('<h1>Model Progress Dashboard</h1>')
    f.write('<div class="subtitle">Tracking commits and model development</div>')
    f.write('</header>')
    
    f.write('<div class="content">')
    
    if not log:
        f.write('<div class="no-data">')
        f.write('<div>No progress data available</div>')
        f.write('</div>')
    else:
        for entry in log:
            sha = entry.get("commit", "unknown")
            branch = entry.get("branch", "unknown")
            ts = entry.get("timestamp", "")
            msg = entry.get("message", "")
            subject = entry.get("subject", "")
            body = entry.get("body", "")
            plot1 = entry.get("plot1", "")
            plot2 = entry.get("plot2", "")
            files = entry.get("changed_files", [])
            reflog = entry.get("reflog", [])
            
            tooltip_link = create_tooltip_sha(sha, reflog)
            formatted_time = format_timestamp(ts)
            
            f.write('<div class="commit-entry">')
            
            # Header with commit info
            f.write('<div class="commit-header">')
            f.write(f'<div>{tooltip_link}</div>')
            f.write(f'<div class="branch-badge">{branch}</div>')
            f.write(f'<div class="timestamp">{formatted_time}</div>')
            f.write('</div>')
            
            # Commit message with subject and body
            if subject or body or msg:
                f.write('<div class="message-section">')
                f.write('<div class="section-title">Commit Message</div>')
                
                # Display subject if available
                if subject:
                    f.write('<div class="commit-subject">')
                    f.write(f'<div class="subject-label">Subject:</div>')
                    f.write(f'<div class="subject-text">{html.escape(subject)}</div>')
                    f.write('</div>')
                
                # Display body if available
                if body:
                    f.write('<div class="commit-body">')
                    f.write(f'<div class="body-label">Body:</div>')
                    f.write(f'<div class="body-text">{html.escape(body)}</div>')
                    f.write('</div>')
                
                # Fallback to full message if subject/body not available
                if not subject and not body and msg:
                    f.write(f'<div class="commit-message">{html.escape(msg)}</div>')
                
                f.write('</div>')
            
            # Changed files
            if files:
                f.write('<div class="files-section">')
                f.write('<div class="section-title">Changed Files</div>')
                f.write('<ul class="files-list">')
                for fname in files:
                    f.write(f'<li>{html.escape(fname.strip())}</li>')
                f.write('</ul>')
                f.write('</div>')
            
            # Plots
            if plot1 or plot2:
                f.write('<div class="plots-section">')
                f.write('<div class="section-title">Generated Plots</div>')
                f.write('<div class="plot-container">')
                
                if plot1:
                    f.write('<div class="plot-item">')
                    f.write(f'<img src="../{plot1}" alt="Plot 1" loading="lazy">')
                    f.write('<div class="plot-label">Plot 1</div>')
                    f.write('</div>')
                
                if plot2:
                    f.write('<div class="plot-item">')
                    f.write(f'<img src="../{plot2}" alt="Plot 2" loading="lazy">')
                    f.write('<div class="plot-label">Plot 2</div>')
                    f.write('</div>')
                
                f.write('</div>')
                f.write('</div>')
            
            f.write('</div>')  # End commit-entry
    
    f.write('</div>')  # End content
    f.write('</div>')  # End container
    f.write('</body>')
    f.write('</html>')

print(f"Generated pretty HTML file: {html_path}")