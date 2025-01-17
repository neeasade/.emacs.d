#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path


EMACS_SHA = "db106ea88b41e7b293f18a587cbe43685cb769a6"
EMACS_DIR = Path.cwd() / "emacs"


def fetch_sha():
    if not (EMACS_DIR / ".git").exists():
        subprocess.run(["git", "init"], check=True, cwd=EMACS_DIR)

    current_sha = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        check=True,
        cwd=EMACS_DIR,
        stdout=subprocess.PIPE,
        text=True,
    )
    current_sha_str = current_sha.stdout.strip()
    if current_sha_str == EMACS_SHA:
        return

    git_remote = subprocess.run(
        ["git", "remote"],
        check=True,
        cwd=EMACS_DIR,
        stdout=subprocess.PIPE,
        text=True,
    )
    git_remote_str = git_remote.stdout.strip()
    if not git_remote_str:
        subprocess.run(
            ["git", "remote", "add", "origin", "https://github.com/emacs-mirror/emacs"],
            check=True,
            cwd=EMACS_DIR,
        )

    subprocess.run(
        ["git", "fetch", "origin", EMACS_SHA],
        check=True,
        cwd=EMACS_DIR,
    )
    subprocess.run(
        ["git", "reset", "--hard", "FETCH_HEAD"],
        check=True,
        cwd=EMACS_DIR,
    )


def fetch_dependencies():
    sentinel = Path.cwd() / ".fetched_dependencies"
    if sentinel.exists():
        return

    if sys.platform != "darwin":
        exit("Cannot install dependencies on a non-macOS system")

    subprocess.run(
        [
            "brew",
            "install",
	    "autoconf",
            "gcc",
	    "gnutls",
	    "jansson",
	    "libgccjit",
	    "texinfo",
        ],
        check=True,
    )

    sentinel.touch()


def compile():
    subprocess.run(
        ["bash", "autogen.sh"],
        check=True,
        cwd=EMACS_DIR,
    )
    subprocess.run(
        [
            "bash",
            "configure",
            "--with-cairo",
            "--with-json",
            "--with-native-compilation",
            "--with-x",
            "--without-mailutils",
            "CFLAGS=-O3 -mtune=native -fomit-frame-pointer -I/opt/homebrew/include",
        ],
        check=True,
        cwd=EMACS_DIR,
    )
    subprocess.run(
        ["make"],
        check=True,
        cwd=EMACS_DIR,
    )
    subprocess.run(
        ["sudo", "make", "install"],
        check=True,
        cwd=EMACS_DIR,
    )

    pass



if __name__ == "__main__":
    fetch_sha()
    fetch_dependencies()
    compile()
