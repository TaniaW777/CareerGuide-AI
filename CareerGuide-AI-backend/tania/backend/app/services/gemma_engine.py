"""
Gemma Engine – Loads the Gemma model via Mediapipe GenAI LLM task.
This is optimized for on-device inference (offline-first).
"""

from __future__ import annotations
import logging
import os
from pathlib import Path
from typing import Optional

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Singleton model holder
# ---------------------------------------------------------------------------
_generator = None
_load_attempted = False

# Path to the Mediapipe .task file
MODEL_PATH = os.getenv("GEMMA_MODEL_PATH", os.path.join("models", "gemma3-1b-it-int4.task"))


def _try_load() -> bool:
    """Attempt to load the Gemma model using Mediapipe."""
    global _generator, _load_attempted
    _load_attempted = True

    if not os.path.exists(MODEL_PATH):
        logger.warning("⚠️ Fichier modèle non trouvé à %s. Impossible de charger Gemma.", MODEL_PATH)
        return False

    try:
        import mediapipe as mp
        from mediapipe.tasks.python.genai import llm

        logger.info("⏳ Chargement du modèle Gemma via Mediapipe (%s) …", MODEL_PATH)
        
        options = llm.LlmInferenceOptions(
            model_path=MODEL_PATH,
            max_tokens=512,
            temperature=0.7,
            top_k=40
        )
        _generator = llm.LlmInference.create_from_options(options)
        
        logger.info("✅ Modèle Gemma chargé avec succès via Mediapipe.")
        return True
    except ImportError:
        logger.error("❌ Erreur: 'mediapipe' n'est pas installé. Veuillez lancer 'pip install mediapipe'.")
        return False
    except Exception as exc:
        logger.error("❌ Erreur lors du chargement de Gemma (Mediapipe): %s", exc)
        return False


def is_ready() -> bool:
    """Return True if the model is loaded and ready."""
    if not _load_attempted:
        _try_load()
    return _generator is not None


def generate(prompt: str) -> Optional[str]:
    """
    Generate text from *prompt* using the loaded Gemma model.
    """
    if not is_ready():
        logger.warning("⚠️ Le modèle Gemma n'est pas prêt.")
        return None

    try:
        logger.info("🤖 Génération de réponse avec Gemma...")
        # Note: Mediapipe generate_response is blocking
        response = _generator.generate_response(prompt)
        return response.strip()
    except Exception as exc:
        logger.error("❌ Erreur Gemma generate: %s", exc)
        return None

def close():
    """Release model resources."""
    global _generator
    if _generator:
        _generator.close()
        _generator = None
