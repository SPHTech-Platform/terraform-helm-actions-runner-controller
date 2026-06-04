#!/bin/bash
# promote-learnings.sh
# Identifies pending learnings and prompts Antigravity to promote them.

echo "Pending Errors:"
grep -B2 -A1 "**Status**: pending" ERRORS.md | grep "\[ERR" || echo "None"

echo -e "\nPending Learnings:"
grep -B2 -A1 "**Status**: pending" LEARNINGS.md | grep "\[LRN" || echo "None"

echo -e "\nTo promote these, ask Antigravity: 'Review my .learnings and prepare an update for GEMINI.md. Ask for my approval before making changes.'"
