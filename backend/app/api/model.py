from fastapi import APIRouter, BackgroundTasks

from app.services.model_manager import (
    model_exists,
    download_model,
    get_progress
)

router = APIRouter()


@router.get("/status")
def status():
    return {
        "downloaded": model_exists()
    }


@router.post("/download")
def download(
    background_tasks: BackgroundTasks
):
    if model_exists():
        return {
            "message": "Model already downloaded",
            "progress": 100
        }

    background_tasks.add_task(
        download_model
    )

    return {
        "message": "Download started",
        "progress": 0
    }


@router.get("/progress")
def progress():
    return {
        "progress": get_progress()
    }