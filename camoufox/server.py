import json
import os
import signal
import subprocess
import sys
import time
from http.client import HTTPConnection, HTTPException
from pathlib import Path
from threading import Event, Thread

from camoufox.addons import DefaultAddons
from camoufox.server import launch_server


def monitor_server(host, port, ws_path, stopped):
    host = {"0.0.0.0": "127.0.0.1", "::": "::1"}.get(host, host)
    expected_path = ws_path if ws_path.startswith("/") else "/" + ws_path
    deadline = time.monotonic() + 120
    ready = False
    failures = 0

    while not stopped.is_set():
        connection = HTTPConnection(host, port, timeout=2)
        healthy = False
        try:
            connection.request("GET", "/json")
            response = connection.getresponse()
            if response.status == 200:
                data = json.loads(response.read(4096))
                healthy = (
                    isinstance(data, dict)
                    and data.get("wsEndpointPath") == expected_path
                )
        except (OSError, HTTPException, ValueError):
            pass
        finally:
            connection.close()

        if stopped.is_set():
            return
        if healthy:
            ready = True
            failures = 0
        elif ready:
            failures += 1

        if (not ready and time.monotonic() >= deadline) or failures >= 3:
            print(
                "Playwright endpoint is unavailable; restarting the browser service",
                file=sys.stderr,
                flush=True,
            )
            # 在主线程中退出，让官方包装先关闭 stdin 并回收 Node 和浏览器。
            os.kill(os.getpid(), signal.SIGUSR1)
            return
        stopped.wait(5)


def main():
    executable = Path(os.environ["CAMOUFOX_EXECUTABLE_PATH"])
    if not executable.is_file():
        raise SystemExit("Camoufox executable is missing from the image")

    try:
        port = int(os.environ["CAMOUFOX_PORT"])
    except (KeyError, ValueError):
        raise SystemExit("CAMOUFOX_PORT must be an integer between 1 and 65535") from None
    if not 1 <= port <= 65535:
        raise SystemExit("CAMOUFOX_PORT must be an integer between 1 and 65535")
    host = os.environ["CAMOUFOX_HOST"]
    ws_path = os.environ["CAMOUFOX_WS_PATH"]
    if not ws_path:
        raise SystemExit("CAMOUFOX_WS_PATH must contain a non-empty path")

    # 与远程桌面共用显示器，避免创建无法通过 KasmVNC 操作的独立显示器。
    deadline = time.monotonic() + 30
    while subprocess.run(
        ["xdpyinfo", "-display", os.environ["DISPLAY"]],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    ).returncode != 0:
        if time.monotonic() >= deadline:
            raise SystemExit("KasmVNC display did not become ready within 30 seconds")
        time.sleep(0.25)

    stopped = Event()

    def stop_service(signum, frame):
        stopped.set()
        raise SystemExit(1 if signum == signal.SIGUSR1 else 0)

    signal.signal(signal.SIGUSR1, stop_service)
    signal.signal(signal.SIGTERM, stop_service)
    monitor = Thread(
        target=monitor_server,
        args=(host, port, ws_path, stopped),
        daemon=True,
    )
    monitor.start()
    try:
        launch_server(
            executable_path=str(executable),
            host=host,
            port=port,
            ws_path=ws_path,
            headless=False,
            geoip=False,
            exclude_addons=[DefaultAddons.UBO],
        )
    finally:
        stopped.set()


if __name__ == "__main__":
    main()
