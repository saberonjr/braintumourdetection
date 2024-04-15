from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import cv2
import numpy as np
import base64
from ultralytics import YOLO
import io
import logging
import os

app = Flask(__name__)
CORS(app)

# Setup logging
logging.basicConfig(level=logging.INFO)

# Load the YOLO model
try:
    model = YOLO('yolo_50epoch.pt')  # Ensure the model filename is correct
    
except Exception as e:
    logging.error(f"Failed to load model: {e}")
    raise RuntimeError("Model loading failed")

def detect_objects(image):
    try:
        # Run inference on the input image
        results = model(image)
        if not results:
            return None
        # Process each result in the list
        for result in results:
            # Plot the detection results on the original image
            annotated_image = result.plot()

            # Convert the annotated image to bytes
            _, img_encoded = cv2.imencode('.png', annotated_image)

        return img_encoded
    except Exception as e:
        logging.error(f"Error in object detection: {e}")
        return None

@app.route('/', methods=['GET'])
def home():
    return "<p>Hello world</p>"

@app.route('/detect', methods=['POST'])
def detect():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    file = request.files['image']
    nparr = np.frombuffer(file.read(), np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if image is None:
        return jsonify({'error': 'Invalid image format'}), 400

    detection_results = detect_objects(image)
    if detection_results is None:
        return jsonify({'error': 'Detection failed or no objects detected'}), 500

    img_bytes = io.BytesIO(detection_results)
    return send_file(img_bytes, mimetype='image/png')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8000))
    app.run()#, port=port)
