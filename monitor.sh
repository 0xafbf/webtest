
WATCH_DIR="src"
ACTION_SCRIPT="build.sh"

echo "Watching for changes in $WATCH_DIR"

while true; do
    inotifywait -r -e modify,create,delete,move "$WATCH_DIR" >/dev/null 2>&1
    echo "Change detected at $(date). Running action script..."
    bash "$ACTION_SCRIPT"
done
