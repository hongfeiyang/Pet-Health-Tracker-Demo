import requests
import json
import time
import subprocess
import threading
import sys

# Start the server in background
def start_server():
    subprocess.run([
        sys.executable, "-m", "uvicorn", 
        "app.main:app", "--host", "0.0.0.0", "--port", "8002"
    ], cwd="/Users/hongfeiyang/dev/med-tracker")

# Start server in background thread
server_thread = threading.Thread(target=start_server, daemon=True)
server_thread.start()

# Wait for server to start
time.sleep(3)

BASE_URL = "http://localhost:8002"

def test_api():
    print("🧪 Testing Pet Health Tracker API")
    print("=" * 50)
    
    # Test root endpoint
    print("1. Testing root endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/")
        print(f"   ✅ Root: {response.status_code} - {response.json()}")
    except Exception as e:
        print(f"   ❌ Root failed: {e}")
    
    # Test health check
    print("2. Testing health check...")
    try:
        response = requests.get(f"{BASE_URL}/health")
        print(f"   ✅ Health: {response.status_code} - {response.json()}")
    except Exception as e:
        print(f"   ❌ Health failed: {e}")
    
    # Test user registration
    print("3. Testing user registration...")
    try:
        user_data = {
            "email": "test@example.com",
            "password": "testpassword123"
        }
        response = requests.post(f"{BASE_URL}/auth/register", json=user_data)
        print(f"   ✅ Registration: {response.status_code}")
        if response.status_code == 200:
            user_id = response.json()["id"]
            print(f"   User ID: {user_id}")
        else:
            print(f"   Response: {response.text}")
    except Exception as e:
        print(f"   ❌ Registration failed: {e}")
    
    # Test user login
    print("4. Testing user login...")
    try:
        login_data = {
            "email": "test@example.com",
            "password": "testpassword123"
        }
        response = requests.post(f"{BASE_URL}/auth/login", json=login_data)
        print(f"   ✅ Login: {response.status_code}")
        if response.status_code == 200:
            token = response.json()["access_token"]
            print(f"   Token received: {token[:20]}...")
            
            # Test protected endpoint
            print("5. Testing protected endpoint (pets list)...")
            headers = {"Authorization": f"Bearer {token}"}
            response = requests.get(f"{BASE_URL}/pets/", headers=headers)
            print(f"   ✅ Pets list: {response.status_code} - {response.json()}")
            
        else:
            print(f"   Response: {response.text}")
    except Exception as e:
        print(f"   ❌ Login failed: {e}")
    
    # Test vet registration
    print("6. Testing vet registration...")
    try:
        vet_data = {
            "email": "vet@example.com",
            "password": "vetpassword123",
            "name": "Dr. Test Vet",
            "clinic_name": "Test Clinic",
            "license_number": "VET123456"
        }
        response = requests.post(f"{BASE_URL}/auth/vet/register", json=vet_data)
        print(f"   ✅ Vet Registration: {response.status_code}")
        if response.status_code != 200:
            print(f"   Response: {response.text}")
    except Exception as e:
        print(f"   ❌ Vet registration failed: {e}")
    
    print("\n🎉 API Testing Complete!")
    print("\n📊 API Documentation available at: http://localhost:8002/docs")

if __name__ == "__main__":
    test_api()