from pathlib import Path
from dataclasses import dataclass
from typing import Optional


@dataclass
class Repository:
    """
    The (relative) path of the repository you want to have updated
    """
    local: Path
    """
    The branch you want to track.
    """
    branch: str
    """
    The remote origin for this branch. Defaults to `"origin"`
    """
    remote: Optional[str]
    """
    The script to run after an update occurs. Path is relative to `local`.
    Set to `None` to not run anything.
    """
    after_update: Optional[Path]
    """
    The script to run after a release occurs
    Set to `None` to not run anything
    """
    after_release: Optional[Path]


"""
Maps repository remotes to configurations. Formatted like
`"p0lyw0lf/github_webhook_watcher"`
"""
REPOSITORIES: dict[str, Repository] = {
    "p0lyw0lf/crossposter": Repository(
        local=Path("..") / "crossposter",
        branch="main",
        remote=None,
        after_update=None,
        after_release=Path("after.sh"),
    ),
    "p0lyw0lf/girl.technology": Repository(
        local=Path("..") / "girl.technology",
        branch="main",
        remote=None,
        after_update=None,
        after_release=Path("after.sh"),
    ),
    "p0lyw0lf/github_webhook_watcher": Repository(
        local=Path("."),
        branch="main",
        remote=None,
        after_update=Path("after.sh"),
        after_release=None,
    ),
    "p0lyw0lf/infrastructure": Repository(
        local=Path("..") / "infrastructure",
        branch="main",
        remote=None,
        after_update=Path("after.sh"),
        after_release=None,
    ),
}
