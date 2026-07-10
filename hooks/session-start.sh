#!/usr/bin/env bash
# SessionStart: inject the working-practices reminder + any open inter-session messages.
NS="${NIGHTSHIFT_HOME:-$HOME/.nightshift}"
REM="${NIGHTSHIFT_REMINDER:-$NS/reminder.txt}"
ctx="$( [ -f "$REM" ] && cat "$REM" )"
# opt-in observation register (MIRROR=1 in config): invite observations about the human
if grep -q '^MIRROR=1' "$NS/config" 2>/dev/null; then ctx="$ctx

Also: when you notice something real about your human collaborator — a pattern, a blind spot, a call worth revisiting — log it with: nightshift observe <session> \"...\". It goes to a PRIVATE review inbox (nightshift mirror), never the shared page. It records; it does not act."
fi
inbox="$(NIGHTSHIFT_HOME="$NS" python3 "$(dirname "$0")/../lib/inbox.py" all 2>/dev/null)"
# cap injection so a flooded inbox can't bloat session context
n=$(printf '%s\n' "$inbox" | wc -l | tr -d ' ')
[ "$n" -gt 12 ] && inbox="$(printf '%s\n' "$inbox" | tail -12)
(…$((n-12)) older open messages — run: nightshift inbox)"
case "$inbox" in ""|"(inbox empty)"|"(no messages)") : ;; *) ctx="$ctx

OPEN INTER-SESSION MESSAGES (nowish) — claim yours: nightshift pick <id> <your-session>
$inbox" ;; esac
python3 -c "import json,sys;print(json.dumps({'hookSpecificOutput':{'hookEventName':'SessionStart','additionalContext':sys.stdin.read()}}))" <<<"$ctx"
