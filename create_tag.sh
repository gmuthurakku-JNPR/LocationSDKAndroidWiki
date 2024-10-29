# Set variables
GITHUB_TOKEN="${GITHUB_TOKEN:?You must set GITHUB_TOKEN}"
CIRCLE_PROJECT_USERNAME="${CIRCLE_PROJECT_USERNAME:?You must set CIRCLE_PROJECT_USERNAME}"
CIRCLE_PROJECT_REPONAME="${CIRCLE_PROJECT_REPONAME:?You must set CIRCLE_PROJECT_REPONAME}"
CIRCLE_SHA1="${CIRCLE_SHA1:?You must set CIRCLE_SHA1}"

# Directory containing artifacts to upload
ARTIFACTS_DIR="./artifacts"
if [ ! -d "$ARTIFACTS_DIR" ]; then
    echo "Artifacts directory ($ARTIFACTS_DIR) does not exist."
    exit 1
fi
version=$(awk -F' = ' '/MARKETING_VERSION/ {sub(/;/, "", $2); print $2}' ./Mist.xcodeproj/project.pbxproj | tail -n 1)
build_number=$(agvtool what-version -terse)
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Run the ghr command to create the release with the specified tag, title, and description
release_title="${tag_name}"
release_body=$(printf "## This build is uploaded from the _%s_ branch. \n\n ### It has fixes for:\n\n%s" "$branch_name" "$release_body")

ghr -t "${GITHUB_TOKEN}" \
    -u "${CIRCLE_PROJECT_USERNAME}" \
    -r "${CIRCLE_PROJECT_REPONAME}" \
    -c "${CIRCLE_SHA1}" \
    -delete \
    -n "${release_title}" \
    -b "${release_body}" \
    "${version}-${build_number}" \
    "$ARTIFACTS_DIR"

echo "Release ${VERSION} created successfully with title '${RELEASE_TITLE}' and description '${RELEASE_DESCRIPTION}'."
