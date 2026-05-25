import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python.genai import llm_bundler, llm_inference

# Charger le modèle
model_path = "backend/models/gemma2-2b-it.task"

# Configurer l'inférence
base_options = python.BaseOptions(model_asset_path=model_path)
options = llm_inference.LlmInferenceOptions(
    base_options=base_options,
    model_token_limit=2048,
    temperature=0.7,
    max_output_tokens=256
)

# Créer l'interpréteur
with llm_inference.LlmInference.create_from_options(options) as interpreter:
    # Générer une réponse
    response = interpreter.generate_response("Bonjour ! Comment vas-tu ?")
    print(response.text)