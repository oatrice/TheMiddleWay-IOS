# Luma Code Review Report

**Date:** 2026-02-11 15:45:25
**Files Reviewed:** ['.github/workflows/auto-tag.yml']

## 📝 Reviewer Feedback

The provided GitHub Actions workflow has a critical logic issue in its version extraction step that makes it brittle and prone to failure.

**Problem:**

The script uses a `grep | head -1 | sed` pipeline to find the version number. This approach has two main flaws:

1.  **Picks the First Match:** An Xcode project file (`.pbxproj`) often contains multiple `MARKETING_VERSION` entries, one for each build configuration (e.g., Debug, Release). If these versions ever differ, the script will arbitrarily pick the first one it finds, which may not be the intended version for tagging.
2.  **No Validation:** If the `grep` and `sed` commands fail to extract a version for any reason (e.g., a change in the `.pbxproj` format), the `VERSION` variable will be empty. The script does not check for this, and will proceed to create and push an invalid tag named `v`.

**Fix:**

The version extraction step should be made more robust. It should verify that all `MARKETING_VERSION` entries in the file are identical and fail gracefully if they are not, or if no version is found.

Replace the `Extract version from project.pbxproj` step with the following:

```yaml
      - name: Extract and validate version from project.pbxproj
        id: version
        run: |
          PBXPROJ=$(find . -name "project.pbxproj" | head -1)
          if [ -z "$PBXPROJ" ]; then
            echo "::error::project.pbxproj not found."
            exit 1
          fi

          # Extract all marketing versions, clean them up, and find the unique ones
          UNIQUE_VERSIONS=$(grep 'MARKETING_VERSION' "$PBXPROJ" | sed 's/.*= *\(.*\);/\1/' | tr -d '[:space:]' | uniq)
          
          # Count the number of unique, non-empty version strings found
          NUM_UNIQUE=$(echo "$UNIQUE_VERSIONS" | grep -c .)

          if [ "$NUM_UNIQUE" -ne 1 ]; then
            echo "::error::Error: Found multiple different MARKETING_VERSION values or no value was found."
            echo "Please ensure all build configurations have the same version number in $PBXPROJ."
            echo "Unique versions found:"
            echo "$UNIQUE_VERSIONS"
            exit 1
          fi

          VERSION=$UNIQUE_VERSIONS
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "tag=v$VERSION" >> $GITHUB_OUTPUT
          echo "📦 Detected version: $VERSION (from $PBXPROJ)"
```

This revised script first finds all unique version strings. It then checks if exactly one unique version was found. If not (i.e., zero or more than one), it fails the workflow with a clear error message, preventing the creation of an incorrect or empty tag.

## 🧪 Test Suggestions

*   **Multiple `project.pbxproj` files:** Create a repository with two or more Xcode projects (e.g., `ProjectA/ProjectA.xcodeproj` and `ProjectB/ProjectB.xcodeproj`). Modify the `MARKETING_VERSION` only in the project that does not come first alphabetically (`ProjectB`). The test should verify that the workflow incorrectly extracts the version from the first project it finds (`ProjectA`) and either creates the wrong tag or skips the process.

*   **Multiple `MARKETING_VERSION` entries in one file:** Modify a `project.pbxproj` to have different `MARKETING_VERSION` values for different build configurations (e.g., `1.2.3` for Release and `1.2.4-debug` for Debug). Ensure the Debug configuration appears before the Release configuration in the file. The test should verify that the workflow incorrectly extracts the first version it finds (`1.2.4-debug`) instead of the intended release version.

*   **Version string containing quotes:** Set the version in the `.pbxproj` file with explicit quotes, such as `MARKETING_VERSION = "2.0.0";`. The test should verify that the script incorrectly extracts the version as `"2.0.0"` (including the quotes) and attempts to create an invalid tag like `v"2.0.0"`.

