import os
import subprocess
from pathlib import Path


def main():
    password = os.environ.pop("KASMVNC_PASSWORD", "")
    if len(password) < 6 or "\n" in password or "\r" in password:
        raise SystemExit(
            "KASMVNC_PASSWORD must contain at least 6 characters and no newlines"
        )

    for name in ("DISPLAY_WIDTH", "DISPLAY_HEIGHT"):
        try:
            value = int(os.environ[name])
        except (KeyError, ValueError):
            raise SystemExit(f"{name} must be a positive integer") from None
        if value <= 0:
            raise SystemExit(f"{name} must be a positive integer")
        os.environ[name] = str(value)

    os.umask(0o077)
    vnc_dir = Path.home() / ".vnc"
    vnc_dir.mkdir(mode=0o700, parents=True, exist_ok=True)

    subprocess.run(
        ["vncpasswd", "-u", "camoufox", "-w", "-r"],
        input=f"{password}\n{password}\n",
        text=True,
        check=True,
    )
    del password

    cert = vnc_dir / "tls.crt"
    key = vnc_dir / "tls.key"
    if not cert.exists() or not key.exists():
        subprocess.run(
            [
                "openssl",
                "req",
                "-x509",
                "-newkey",
                "rsa:2048",
                "-nodes",
                "-keyout",
                str(key),
                "-out",
                str(cert),
                "-days",
                "3650",
                "-subj",
                "/CN=camoufox",
            ],
            check=True,
        )

    os.execvp("supervisord", ["supervisord", "-c", "/app/supervisord.conf"])


if __name__ == "__main__":
    main()
