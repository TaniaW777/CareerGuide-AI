import pytest
from app.services.scoring import recommend

def test_recommend_tle_d():
    profile = {
        "class_level": "Tle",
        "stream": "D",
        "favorite_subjects": ["SVT", "Physique-Chimie"],
        "interests": ["Santé et Bien Être"]
    }
    results = recommend(profile)
    # Médecine & Santé devrait être premier
    assert results[0][0] == "Médecine & Santé"
    assert results[0][1] >= 80 # 50 (série D) + 30 (intérêt santé)

def test_recommend_tle_c():
    profile = {
        "class_level": "Tle",
        "stream": "C",
        "favorite_subjects": ["Mathématiques", "Informatique"],
        "interests": ["Science et Technologie"]
    }
    results = recommend(profile)
    assert results[0][0] == "Génie Logiciel & IA"

def test_recommend_3eme_science():
    profile = {
        "class_level": "3ème",
        "favorite_subjects": ["Mathématiques", "SVT"],
        "interests": ["Science et Technologie"]
    }
    results = recommend(profile)
    assert results[0][0] == "Lycée Scientifique"
