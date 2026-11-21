#!/usr/bin/env bash
# Claude Code status line: "<model> · <dir relative to ~> (<branch>) · ctx <bar> NN%"
input=$(cat)
model=$(printf '%s' "$input" | /usr/bin/jq -r '.model.display_name // empty' 2>/dev/null)
pct=$(printf '%s' "$input" | /usr/bin/jq -r '
  (.context_window.used_percentage
   // (if (.context_window.current_usage != null and (.context_window.context_window_size // 0) > 0)
       then ((.context_window.current_usage.input_tokens // 0)
             + (.context_window.current_usage.cache_creation_input_tokens // 0)
             + (.context_window.current_usage.cache_read_input_tokens // 0))
            * 100 / .context_window.context_window_size
       else empty end)) // empty' 2>/dev/null)

dir=$(printf '%s' "$input" | /usr/bin/jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
branch=""
if [ -n "$dir" ]; then
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi
if [ -n "$dir" ]; then
  if [ "$dir" = "$HOME" ]; then dir="root"
  else dir="${dir#"$HOME"/}"; fi
fi

prefix=""
[ -n "$model" ] && prefix="$model · "
if [ -n "$dir" ]; then
  c_dir=$'\033[1;34m'; c_branch=$'\033[1;32m'; c_off=$'\033[0m'
  if [ -n "$branch" ]; then prefix="${prefix}${c_dir}${dir}${c_off} ${c_branch}(${branch})${c_off} · "
  else prefix="${prefix}${c_dir}${dir}${c_off} · "; fi
fi

if [ -z "$pct" ]; then
  printf '%sctx –' "$prefix"
  exit 0
fi

p=$(printf '%.0f' "$pct")
[ "$p" -lt 0 ] && p=0
[ "$p" -gt 100 ] && p=100
filled=$(( (p + 5) / 10 ))
bar=""
for i in 1 2 3 4 5 6 7 8 9 10; do
  if [ "$i" -le "$filled" ]; then bar="${bar}▓"; else bar="${bar}░"; fi
done

if [ "$p" -ge 80 ]; then color='\033[31m'
elif [ "$p" -ge 50 ]; then color='\033[33m'
else color='\033[35m'; fi

printf "%s${color}ctx %s %s%%\033[0m" "$prefix" "$bar" "$p"
