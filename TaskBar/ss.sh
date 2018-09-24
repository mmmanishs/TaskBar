DOCUMENTS_DIRECTORY="$HOME/Documents/Screenshots"
DESKTOP_DIRECTORY="$HOME/Desktop"

TODAY_SCREENSHOTS_DIR="$DOCUMENTS_DIRECTORY/$(date '+%d-%b-%Y')"
mkdir "$DOCUMENTS_DIRECTORY"

mkdir "$TODAY_SCREENSHOTS_DIR"


ls -d $DESKTOP_DIRECTORY/Screen\ Shot*.png | xargs -I {} mv {} $TODAY_SCREENSHOTS_DIR

echo "Finished cleaning up!!"
