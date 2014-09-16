#! /bin/sh
function usage() {
    echo
    echo "    ./$(basename "$0") <url> <save_location>"
    echo
    echo '    Download a file if possible using, curl, wget, w3m, or lynx'
    echo '    returns 1 if added, 0 if not added, and 2 if error or help is shown'
    echo
    echo '    <url>            the url of the file you want to download'
    echo '    <save_location>  the location to save the file'
    echo
    exit 2
}
for arg in "$@"; do
    if [ -n "$(echo "$arg" | grep -E '^--?(h|help)')" ]; then
        usage
    fi
done
if [ -z "$1" ] || [ -z "$2" ]; then
    usage
fi

url="$1"; shift;
save_location="$1"; shift;

if command -v 'wget' > /dev/null;then
    echo "Downloading $url using wget"
    wget -O "$save_location" "$url" -q --no-check-certificate
    exit "$?"
elif command -v 'curl' > /dev/null; then
    echo "Downloading $url using curl"
    curl -o "$save_location" "$url" -q
    exit "$?"
elif command -v 'w3m' > /dev/null; then
    echo "Downloading $url using w3m"
    w3m -dump "$url" > "$save_location"
    exit "$?"
elif command -v 'lynx' > /dev/null; then
    echo "Downloading $url using lynx"
    lynx -dump "$url" > "$save_location"
    exit "$?"
fi

echo "We require curl, wget, lynx, or w3m to use the download function"
exit 2
