"""
Gemini Engine – Uses Google Gemini via the google-generativeai SDK.
This is the online fallback when internet is available and a valid API key is configured.
"""

from __future__ import annotations
import logging
import os
from typing import Optional

logger = logging.getLogger(__name__)

API_KEY = (
    os.getenv("GOOGLE_API_KEY")
    or os.getenv("GEMINI_API_KEY")
    or os.getenv("Gemini_API_Key")
)
MODEL_NAME = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")

_client = None


def is_available() -> bool:
    """Return True when Gemini can be used (API key is configured)."""
    return bool(API_KEY)


def _ensure_client():
    global _client
    if _client is not None:
        return _client

    if not API_KEY:
        logger.warning(
            "⚠️ Gemini API key not configured. Set GOOGLE_API_KEY, GEMINI_API_KEY or Gemini_API_Key."
        )
        return None

    try:
        import google.generativeai as genai
        _client = genai.Client(api_key=API_KEY)
        return _client
    except ImportError:
        logger.error("❌ google-generativeai n'est pas installé. Veuillez ajouter google-generativeai à requirements.txt.")
        return None
    except Exception as exc:
        logger.error("❌ Impossible d'initialiser le client Gemini: %s", exc)
        return None


def generate(prompt: str, max_output_tokens: int = 512) -> Optional[str]:
    """Generate text from Gemini using the configured API key."""
    client = _ensure_client()
    if not client:
        return None

    try:
        logger.info("🌐 Génération de réponse via Gemini (%s)...", MODEL_NAME)
        response = client.responses.create(
            model=MODEL_NAME,
            text=prompt,
            max_output_tokens=max_output_tokens,
        )

        output_text = None
        if hasattr(response, "output_text") and response.output_text:
            output_text = response.output_text
        elif hasattr(response, "output") and response.output:
            output = response.output
            if isinstance(output, list) and len(output) > 0:
                first = output[0]
                if isinstance(first, dict):
                    contents = first.get("content") or []
                    if isinstance(contents, list) and len(contents) > 0:
                        first_content = contents[0]
                        output_text = first_content.get("text") if isinstance(first_content, dict) else None
        if output_text:
            return output_text.strip()
        return None
    except Exception as exc:
        logger.error("❌ Erreur Gemini generate: %s", exc)
        return None
