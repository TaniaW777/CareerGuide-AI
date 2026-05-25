from pathlib import Path
import os
import httpx

MODEL_PATH = Path(os.getenv("GEMMA_MODEL_PATH", Path("models") / "gemma3-1b-it-int4.task"))
MODEL_DIR = MODEL_PATH.parent

# Remplacer plus tard par la vraie URL
MODEL_URL = "https://github.com/TaniaW777/CareerGuide-AI/releases/download/v1.0/gemma3-1B-it-int4.task"

DOWNLOAD_PROGRESS = 0


def model_exists():
    return MODEL_PATH.exists()


def get_progress():
    if model_exists():
        return 100

    return DOWNLOAD_PROGRESS


def download_model():
    global DOWNLOAD_PROGRESS

    MODEL_DIR.mkdir(exist_ok=True)

    with httpx.stream("GET", MODEL_URL) as response:
        response.raise_for_status()

        total = int(
            response.headers.get(
                "content-length", 0
            )
        )

        downloaded = 0

        with open(MODEL_PATH, "wb") as f:
            for chunk in response.iter_bytes():
                f.write(chunk)

                downloaded += len(chunk)

                DOWNLOAD_PROGRESS = int(
                    downloaded * 100 / total
                )

                print(
                    f"Download: {DOWNLOAD_PROGRESS}%"
                )

    DOWNLOAD_PROGRESS = 100