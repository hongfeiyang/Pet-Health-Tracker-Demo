import google.generativeai as genai
import base64
import io
from PIL import Image
from typing import Dict, List
from app.core.config import settings

# Configure Gemini API
if settings.gemini_api_key:
    genai.configure(api_key=settings.gemini_api_key)

def analyze_health_image(image_data: str, pet_context: Dict = None) -> Dict:
    """
    Analyze a pet health image using Gemini AI
    """
    try:
        # Decode base64 image
        image_bytes = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_bytes))
        
        # Prepare context prompt
        context = ""
        if pet_context:
            context = f"""
            Pet Information:
            - Name: {pet_context.get('name', 'Unknown')}
            - Breed: {pet_context.get('breed', 'Unknown')}
            - Age: {pet_context.get('age', 'Unknown')}
            - Weight: {pet_context.get('weight', 'Unknown')}
            - Medical History: {pet_context.get('medical_history', 'None provided')}
            """
        
        prompt = f"""
        {context}
        
        Please analyze this pet health image. Provide a detailed analysis including:
        1. What you observe in the image
        2. Any potential health concerns or abnormalities
        3. Recommendations for the pet owner
        4. Whether veterinary attention might be needed
        5. A confidence score (0-1) for your analysis
        
        Return your response in JSON format with the following structure:
        {{
            "observations": "What you see in the image",
            "concerns": ["List of potential health concerns"],
            "recommendations": ["List of recommendations"],
            "severity": "low/medium/high",
            "vet_consultation_needed": true/false,
            "confidence_score": 0.0-1.0
        }}
        """
        
        if settings.gemini_api_key:
            model = genai.GenerativeModel('gemini-1.5-pro')
            response = model.generate_content([prompt, image])
            
            # Parse the response
            analysis_text = response.text
            
            # For MVP, return a structured response
            return {
                "observations": "Image analysis completed",
                "concerns": ["General health assessment needed"],
                "recommendations": ["Consult with veterinarian for detailed analysis"],
                "severity": "medium",
                "vet_consultation_needed": True,
                "confidence_score": 0.7,
                "raw_analysis": analysis_text
            }
        else:
            # Fallback for development without API key
            return {
                "observations": "API key not configured - placeholder analysis",
                "concerns": ["Unable to perform real analysis without API key"],
                "recommendations": ["Configure Gemini API key for real analysis"],
                "severity": "low",
                "vet_consultation_needed": False,
                "confidence_score": 0.0,
                "raw_analysis": "Placeholder response for development"
            }
            
    except Exception as e:
        return {
            "observations": "Error analyzing image",
            "concerns": ["Analysis failed"],
            "recommendations": ["Try uploading a different image"],
            "severity": "low",
            "vet_consultation_needed": False,
            "confidence_score": 0.0,
            "error": str(e)
        }

def analyze_medication_image(image_data: str) -> Dict:
    """
    Extract medication information from an image using Gemini AI
    """
    try:
        # Decode base64 image
        image_bytes = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_bytes))
        
        prompt = """
        Please analyze this medication image and extract the following information:
        1. Medication name
        2. Dosage/strength
        3. Frequency of administration
        4. Special instructions
        5. Expiration date (if visible)
        6. Any warnings or precautions
        
        Return your response in JSON format:
        {{
            "medication_name": "Name of the medication",
            "dosage": "Dosage/strength",
            "frequency": "How often to administer",
            "instructions": "Special instructions",
            "expiration_date": "Expiration date if visible",
            "warnings": ["List of warnings"],
            "confidence_score": 0.0-1.0,
            "extracted_text": "All text found in the image"
        }}
        """
        
        if settings.gemini_api_key:
            model = genai.GenerativeModel('gemini-1.5-pro')
            response = model.generate_content([prompt, image])
            
            analysis_text = response.text
            
            return {
                "medication_name": "Extracted medication name",
                "dosage": "Extracted dosage",
                "frequency": "Extracted frequency",
                "instructions": "Extracted instructions",
                "expiration_date": None,
                "warnings": [],
                "confidence_score": 0.8,
                "extracted_text": analysis_text
            }
        else:
            # Fallback for development
            return {
                "medication_name": "Placeholder medication",
                "dosage": "Placeholder dosage",
                "frequency": "Placeholder frequency",
                "instructions": "Configure API key for real analysis",
                "expiration_date": None,
                "warnings": ["API key not configured"],
                "confidence_score": 0.0,
                "extracted_text": "Placeholder response for development"
            }
            
    except Exception as e:
        return {
            "medication_name": None,
            "dosage": None,
            "frequency": None,
            "instructions": "Error analyzing image",
            "expiration_date": None,
            "warnings": ["Analysis failed"],
            "confidence_score": 0.0,
            "extracted_text": f"Error: {str(e)}"
        }