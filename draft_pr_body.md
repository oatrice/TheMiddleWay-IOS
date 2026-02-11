Closes: https://github.com/{owner}/{repo}/issues/5

### Summary

This pull request introduces a robust CI workflow to automate the creation of Git tags whenever the application's version is updated in the Xcode project file. This change streamlines the release process and eliminates manual tagging errors. As part of this work, the app version has been bumped to `0.3.1` to trigger the new workflow and formally release these CI improvements.

**Note:** The linked issue title, "[Data] CSV Data Ingestion...", does not appear to align with the changes in this pull request, which are focused on CI automation for release tagging.

### Problem

Manually creating and pushing Git tags for each release is a repetitive and error-prone task. It's easy to forget, mistype the version, or create a tag that doesn't match the `MARKETING_VERSION` in the `.pbxproj` file. This leads to inconsistencies between the codebase and its release markers.

### Solution

An automated GitHub Actions workflow (`auto-tag.yml`) has been implemented to handle this process securely and reliably.

**Key Features of the New Workflow:**

*   **Automatic Trigger:** The workflow runs automatically on any push to the `main` branch that modifies a `*.pbxproj` file.
*   **Robust Version Extraction:** The script extracts *all* `MARKETING_VERSION` values from the project file and verifies that there is exactly one unique version across all build configurations. This prevents accidentally tagging a release with a debug or mismatched version number. If inconsistencies are found, the workflow fails with a clear error message.
*   **Idempotency:** Before creating a tag, the workflow checks if one for the extracted version (e.g., `v0.3.1`) already exists. If it does, the process is skipped gracefully, preventing errors on re-runs.
*   **Automated Tagging:** If the tag is new, the workflow creates and pushes a new annotated Git tag using a bot identity.

### Changes Included

*   **CI (`.github/workflows/auto-tag.yml`):** Added the new workflow for automated version tagging.
*   **Version Bump (`TheMiddleWay.xcodeproj/project.pbxproj`):** Incremented the app version from `0.3.0` to `0.3.1`.
*   **Changelog (`CHANGELOG.md`):** Updated with an entry for `v0.3.1` to document the CI improvements.
*   **Documentation (`code_review.md`):** Updated the code review report to analyze the logic and robustness of the new auto-tagging workflow.

### Impact

*   **Streamlined Releases:** The release process is now more efficient and less manual.
*   **Improved Consistency:** Guarantees that Git tags are always synchronized with the version specified in the Xcode project.
*   **Reduced Human Error:** Eliminates the possibility of manual mistakes during the tagging process.