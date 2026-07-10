#!/usr/bin/env bash
# SessionStart: inject the working-practices reminder + any open inter-session messages.
NS="${NIGHTSHIFT_HOME:-$HOME/.nightshift}"
REM="${NIGHTSHIFT_REMINDER:-$NS/reminder.txt}"
ctx="$( [ -f "$REM" ] && cat "$REM" )"
inbox="$(NIGHTSHIFT_HOME="$NS" python3 "$(dirname "$0")/../lib/inbox.py" all 2>/dev/null)"
# cap injection so a flooded inbox can't bloat session context
n=$(printf '%s\n' "$inbox" | wc -l | tr -d ' ')
[ "$n" -gt 12 ] && inbox="$(printf '%s\n' "$inbox" | tail -12)
(…$((n-12)) older open messages — run: nightshift inbox)"
case "$inbox" in ""|"(inbox empty)"|"(no messages)") : ;; *) ctx="$ctx

OPEN INTER-SESSION MESSAGES (nowish) — claim yours: nightshift pick <id> <your-session>
$inbox" ;; esac
python3 -c "import json,sys;print(json.dumps({'hookSpecificOutput':{'hookEventName':'SessionStart','additionalContext':sys.stdin.read()}}))" <<<"$ctx"
