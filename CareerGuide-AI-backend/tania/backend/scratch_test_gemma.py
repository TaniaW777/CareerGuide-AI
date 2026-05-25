import sys
try:
    import mediapipe as mp
    from mediapipe.tasks.python.genai import llm
    print("✅ Mediapipe imported successfully!")
except Exception as e:
    print(f"❌ Failed to import mediapipe: {e}")
    sys.exit(1)

import os
model_path = "models/gemma3-1b-it-int4.task"
if not os.path.exists(model_path):
    print(f"❌ Model file not found at {model_path}")
    sys.exit(1)

print("🚀 Loading Gemma model in Mediapipe...")
try:
    options = llm.LlmInferenceOptions(
        model_path=model_path,
        max_tokens=256,
        temperature=0.7
    )
    with llm.LlmInference.create_from_options(options) as generator:
        print("✅ Model loaded successfully!")
        print("🤖 Testing generation...")
        prompt = "Tu es un conseiller d'orientation. Réponds par une phrase courte: quel est le rôle d'un ingénieur?"
        response = generator.generate_response(prompt)
        print(f"Response: {response}")
except Exception as e:
    print(f"❌ Error during loading/generation: {e}")
