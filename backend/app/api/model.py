from fastapi import APIRouter

router = APIRouter()


@router.get("/status")
def model_status():
    return {
        "mode": "local",
        "message": "Model is managed locally on device"
    }