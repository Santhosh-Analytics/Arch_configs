#!/usr/bin/env python3

import logging

logging.basicConfig(filename='/tmp/waybar_notifications.log', level=logging.DEBUG)


import json
import subprocess
import sys
import traceback

def get_mako_notifications():
    try:
        output = subprocess.check_output(['makoctl', 'list'], universal_newlines=True)
        notifications = output.strip().split('\n')
        return len(notifications) if notifications[0] else 0
    except subprocess.CalledProcessError as e:
        sys.stderr.write(f"Error running makoctl: {e}\n")
        return 0
    except Exception as e:
        sys.stderr.write(f"Unexpected error: {e}\n")
        traceback.print_exc(file=sys.stderr)
        return 0

def main():
    try:
        count = get_mako_notifications()
        
        output = {
            "text": str(count),
            "tooltip": f"{count} notification{'s' if count != 1 else ''}",
            "class": "notification" if count > 0 else "none"
        }
        
        print(json.dumps(output))
    except Exception as e:
        sys.stderr.write(f"Error in main: {e}\n")
        traceback.print_exc(file=sys.stderr)
        print(json.dumps({"text": "⚠️", "tooltip": f"Error: {str(e)}", "class": "error"}))

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logging.exception("Error in notifications script")
